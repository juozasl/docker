#!/bin/bash

set -e

# if the directory is mounted to your local path
if [ ! -f /usr/local/nagios/etc/htpasswd.users ];then
    cd /usr/local/nagios/ && rm -rf etc/*
    cp -r /usr/local/nagios/etc1/* /usr/local/nagios/etc/
fi

chown -R nagios:nagios /usr/local/nagios/etc 

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
