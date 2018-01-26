#!/bin/bash

set -e

NGINX_REALIP_PROXY=${NGINX_REALIP_PROXY:-"172.17.0.1"}

# configure mongo authentification
if [ ! -f /var/lib/mongodb/.mongodb_configured ]; then
    /set_mongo_auth.sh
fi

# ++ nginx & php-fpm

mkdir -p /var/www/app/web/
mkdir -p /var/www/log/
chown -R www-data:www-data /var/www
sed -i 's/set_real_ip_from 0.0.0.0;/set_real_ip_from '$NGINX_REALIP_PROXY';/' /etc/nginx/sites-available/default
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
if [ ! -f /var/www/app/public/index.php ]; then
    echo "<?php echo 'container ...'; ?>" > /var/www/app/public/index.php
fi

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
