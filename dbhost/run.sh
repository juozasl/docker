#!/bin/bash

set -e

# init mysql db if necessary
if [ ! -d /var/lib/mysql/mysql ];then
    dpkg-reconfigure mysql-server-5.7
fi

mkdir -p /var/run/mysqld/
chown -R mysql:mysql /var/run/mysqld 

service mysql start

# MYSQL DATABASE and USER CREATTION
DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}
MYSQL_CHARSET=${MYSQL_CHARSET:-"utf8"}
MYSQL_COLLATION=${MYSQL_COLLATION:-"utf8_unicode_ci"}

# create new user / database
if [ -n "${DB_USER}" -o -n "${DB_NAME}" ]; then
    /usr/bin/mysqld_safe >/dev/null 2>&1 &

    # wait for mysql server to start (max 30 seconds)
    timeout=30
    while ! /usr/bin/mysqladmin -u root status >/dev/null 2>&1
    do
        timeout=$(($timeout - 1))
        if [ $timeout -eq 0 ]; then
        echo "Could not connect to mysql server. Aborting..."
        exit 1
        fi
        sleep 1
    done

    if [ -n "${DB_NAME}" ]; then

        for db in $(awk -F',' '{for (i = 1 ; i <= NF ; i++) print $i}' <<< "${DB_NAME}"); do
        echo "Creating database \"$db\"..."
        mysql --defaults-file=/etc/mysql/debian.cnf \
            -e "CREATE DATABASE IF NOT EXISTS \`$db\` DEFAULT CHARACTER SET \`$MYSQL_CHARSET\` COLLATE \`$MYSQL_COLLATION\`;"
            if [ -n "${DB_USER}" ]; then
            echo "Granting access to database \"$db\" for user \"${DB_USER}\"..."
            mysql --defaults-file=/etc/mysql/debian.cnf \
            -e "GRANT ALL PRIVILEGES ON \`$db\`.* TO '${DB_USER}' IDENTIFIED BY '${DB_PASS}';"
            fi
        done

    else

        if [ -n "${DB_USER}" ]; then
            echo "Granting access to all databases for user \"${DB_USER}\"..."
            mysql --defaults-file=/etc/mysql/debian.cnf \
            -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}' IDENTIFIED BY '${DB_PASS}';"
        fi
    
    fi
    /usr/bin/mysqladmin --defaults-file=/etc/mysql/debian.cnf shutdown
fi

service mysql stop

# initialize snmpd.conf file if not exist
if [ ! -f /etc/snmp/snmpd.conf ]; then
    echo "rocommunity public 127.0.0.1" > /etc/snmp/snmpd.conf
fi

# cron file initialize if not exist
if [ ! -f /etc/cron.d/app ]; then
    touch /etc/cron.d/app
    chmod 0644 /etc/cron.d/app
fi

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
