#!/bin/bash

set -e

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

# configure authentification
if [ ! -f /root/.mongodb_configured ]; then
    /set_mongodb_password.sh
fi

