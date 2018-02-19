#!/bin/bash

set -e

# MYSQL DATABASE and USER CREATTION
DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}
MYSQL_CHARSET=${MYSQL_CHARSET:-"utf8"}
MYSQL_COLLATION=${MYSQL_COLLATION:-"utf8_unicode_ci"}

service mysql start

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
        mysql \
            -e "CREATE DATABASE IF NOT EXISTS \`$db\` DEFAULT CHARACTER SET \`$MYSQL_CHARSET\` COLLATE \`$MYSQL_COLLATION\`;"
            if [ -n "${DB_USER}" ]; then
            echo "Granting access to all databases for user \"${DB_USER}\"..."
            mysql \
            -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}' IDENTIFIED BY '${DB_PASS}';"
            fi
        done

    else

        if [ -n "${DB_USER}" ]; then
            echo "Granting access to all databases for user \"${DB_USER}\"..."
            mysql \
            -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}' IDENTIFIED BY '${DB_PASS}';"
        fi
    
    fi
    /usr/bin/mysqladmin shutdown
fi

service mysql stop

echo  "done" > /var/lib/mysql/.mysql_configured
