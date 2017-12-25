#!/bin/bash

set -e

# init mysql db if necessary
if [ ! -d /var/lib/mysql/mysql ];then
    mysqld --initialize-insecure --user=root --datadir=/var/lib/mysql
fi

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
