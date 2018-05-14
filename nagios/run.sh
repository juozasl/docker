#!/bin/bash

set -e

ADMIN_EMAIL=${ADMIN_EMAIL:-"admin@localhost"}
NAGIOS_PASS=${NAGIOS_PASS:-"nagiospassword"}
SLACK_DOMAIN=${SLACK_DOMAIN:-"slack_domain"}
SLACK_TOKEN=${SLACK_TOKEN:-"slack_token"}
SLACK_CHANNEL=${SLACK_CHANNEL:-"alerts"}

# if nagios is not configured
if [ ! -f /usr/local/nagios/etc/.nagios_configured ];then
    
    cd /usr/local/nagios/ && rm -rf etc/*
    cp -r /usr/local/nagios/etc1/* /usr/local/nagios/etc/
    sed -i 's/enable_environment_macros=0/enable_environment_macros=1/' /usr/local/nagios/etc/nagios.cfg
    sed -i 's/nagios@localhost/'$ADMIN_EMAIL'/' /usr/local/nagios/etc/objects/contacts.cfg
    sed -i 's/##channel/#'$SLACK_CHANNEL'/' /usr/local/nagios/etc/servers/slack_nagios.cfg
    sed -i 's/members                 nagiosadmin/members                 nagiosadmin,slack/' /usr/local/nagios/etc/objects/contacts.cfg

 
    echo  "done" > /usr/local/nagios/etc/.nagios_configured

fi

# Password setup
htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin $NAGIOS_PASS

chown -R nagios:nagios /usr/local/nagios/etc 

# slack setup
sed -i 's/slack_domain/'$SLACK_DOMAIN'/' /usr/local/bin/slack_nagios.pl
sed -i 's/slack_token/'$SLACK_TOKEN'/' /usr/local/bin/slack_nagios.pl

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
