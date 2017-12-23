#!/bin/bash

# mongodb run
exec /usr/bin/mongod --config /etc/mongod.conf

# mysql run
if [ ! -d /var/lib/mysql/mysql ];then
    mysqld --initialize-insecure --user=root --datadir=/var/lib/mysql
fi

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# snmpd run
/etc/init.d/snmpd start

# cron
cron



