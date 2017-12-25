#!/bin/bash

# ++ permissions

chown -R www-data:www-data /var/www
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# ++ run daemons

services nginx restart

# mysql run
if [ ! -d /var/lib/mysql/mysql ];then
    mysqld --initialize-insecure --user=root --datadir=/var/lib/mysql
fi

# snmpd run
/etc/init.d/snmpd start

# cron
cron
