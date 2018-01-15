#!/bin/bash

set -e

NGINX_REALIP_PROXY=${NGINX_REALIP_PROXY:-"172.17.0.1"}

# ++ create dirs

mkdir -p /var/www/app/web/
mkdir -p /var/www/log/

# ++ permissions

chown -R www-data:www-data /var/www

# ++ config real ip proxy
RUN sed -i 's/set_real_ip_from 0.0.0.0;/set_real_ip_from '$NGINX_REALIP_PROXY';/' /etc/nginx/sites-available/default

# initialize required files
service php7.0-fpm start
service php7.0-fpm stop

# index file initialization if not exist
if [ ! -f /var/www/app/web/index.php ]; then
    echo "<?php echo 'container ...'; ?>" > /var/www/app/web/index.php
fi

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
