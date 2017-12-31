#!/bin/bash

set -e

# configure authentification
if [ ! -f /var/lib/mongodb/.mongodb_configured ]; then
    /set_mongo_auth.sh
fi

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf



