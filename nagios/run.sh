#!/bin/bash

set -e

ADMIN_EMAIL=${ADMIN_EMAIL:-"admin@localhost"}
NAGIOS_PASS=${NAGIOS_PASS:-"nagiospassword"}

# if the directory is mounted to your local path
if [ ! -f /usr/local/nagios/etc/nagios.cfg ];then
    
    cd /usr/local/nagios/ && rm -rf etc/*
    cp -r /usr/local/nagios/etc1/* /usr/local/nagios/etc/
    sed -i 's/nagios@localhost/'$ADMIN_EMAIL'/' /usr/local/nagios/etc/objects/contacts.cfg

fi

# Password setup
htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin $NAGIOS_PASS


chown -R nagios:nagios /usr/local/nagios/etc 

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
