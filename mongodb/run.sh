#!/bin/bash

set -e

# super visor deamons start
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

if [ ! -f /root/.mongodb_configured ]; then
    /set_mongodb_password.sh
fi

# go to foreground
fg
