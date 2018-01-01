#!/bin/bash

set -e

# ++ Mysql

# init mysql db if necessary
if [ ! -d /var/lib/mysql/mysql ];then
    dpkg-reconfigure mysql-server-5.7
fi

mkdir -p /var/run/mysqld/
chown -R mysql:mysql /var/run/mysqld 

# configure mysql authentification
if [ ! -f /var/lib/mysql/.mysql_configured ]; then
    /set_mysql_auth.sh
fi

# ++ nginx & php-fpm

mkdir -p /var/www/app/web/
mkdir -p /var/www/log/
chown -R www-data:www-data /var/www
service php7.0-fpm start
service php7.0-fpm stop

# initialize snmpd.conf file if not exist
if [ ! -f /etc/snmp/snmpd.conf ]; then
    echo "rocommunity public 127.0.0.1" > /etc/snmp/snmpd.conf
fi

# cron file initialize if not exist
if [ ! -f /etc/cron.d/app ]; then
    touch /etc/cron.d/app
    chmod 0644 /etc/cron.d/app
fi

# index file initialization if not exist
if [ ! -f /var/www/app/web/index.php ]; then
    echo "<?php echo 'container ...'; ?>" > /var/www/app/web/index.php
fi

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
