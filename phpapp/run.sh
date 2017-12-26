#!/bin/bash

# ++ create dirs

mkdir -p /var/www/app/web/
mkdir -p /var/www/log/

# ++ permissions

chown -R www-data:www-data /var/www

# initialize required files
service php7.0-fpm start
service php7.0-fpm stop

# index file initialization if not exist
if [ ! -f /var/www/app/web/index.php ]; then
    echo "<?php echo 'container ...'; ?>" > /var/www/app/web/index.php
fi

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

