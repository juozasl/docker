#!/bin/bash

set -e

NGINX_REALIP_PROXY=${NGINX_REALIP_PROXY:-"172.17.0.1"}
FRAMEWORK=${FRAMEWORK:-"yii2"}
UPLOAD_SIZE=${UPLOAD_SIZE:-"20M"}
EXECUTION_TIME=${EXECUTION_TIME:-"60"}

# configure mongo authentification
if [ ! -f /var/lib/mongodb/.mongodb_configured ]; then
    /set_mongo_auth.sh
fi

# ++ nginx & php-fpm

mkdir -p /var/www/log/
chown -R www-data:www-data /var/www

service php7.2-fpm start
service php7.2-fpm stop

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

if [ "$FRAMEWORK" == "yii2" ]; then

    mkdir -p /var/www/app/web/

    cp /etc/nginx/sites-available/default_yii2 /etc/nginx/sites-available/default

    # index file initialization if not exist
    if [ ! -f /var/www/app/web/index.php ]; then
        echo "<?php echo 'container ...'; ?>" > /var/www/app/web/index.php
    fi

fi

if [ "$FRAMEWORK" == "laravel" ]; then

    mkdir -p /var/www/app/public/

    cp /etc/nginx/sites-available/default_laravel /etc/nginx/sites-available/default

    # index file initialization if not exist
    if [ ! -f /var/www/app/public/index.php ]; then
        echo "<?php echo 'container ...'; ?>" > /var/www/app/public/index.php
    fi

fi

sed -i 's/set_real_ip_from 0.0.0.0;/set_real_ip_from '$NGINX_REALIP_PROXY';/' /etc/nginx/sites-available/default

# upload size config
sed -i 's/client_max_body_size 0;/client_max_body_size '$UPLOAD_SIZE';/' /etc/nginx/nginx.conf
sed -i 's/post_max_size = 8M/post_max_size = '$UPLOAD_SIZE'/' /etc/php/7.2/fpm/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = '$UPLOAD_SIZE'/' /etc/php/7.2/fpm/php.ini

# execution time config
sed -i 's/client_header_timeout 0;/client_header_timeout '$EXECUTION_TIME';/' /etc/nginx/nginx.conf
sed -i 's/client_body_timeout 0;/client_body_timeout '$EXECUTION_TIME';/' /etc/nginx/nginx.conf
sed -i 's/fastcgi_read_timeout 0;/fastcgi_read_timeout '$EXECUTION_TIME';/' /etc/nginx/nginx.conf
sed -i 's/max_execution_time = 30/max_execution_time = '$EXECUTION_TIME'/' /etc/php/7.2/fpm/php.ini

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
