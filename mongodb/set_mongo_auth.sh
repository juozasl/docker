#!/bin/bash

set -e

MONGODB_USER=${MONGODB_USER:-}
MONGODB_PASS=${MONGODB_PASS:-}


if [ -n "${MONGODB_USER}" -a -n "${MONGODB_PASS}" ]; then

    # ++ check if mongodb started
    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MongoDB service startup"
        sleep 5
        mongo admin --eval "help" >/dev/null 2>&1
        RET=$?
    done

    echo "=> Creating user"

    mongo admin --eval "db.createUser({user: '$MONGODB_USER', pwd: '$MONGODB_PASS', roles:['root']});"

    echo "=> Done!"

    # ++ add authentication config to mongo config file
    sed -i 's/#security:/security:\n  authorization: "enabled"/' /etc/mongod.conf

    # ++ restart mongodb server
    supervisorctl restart mongodb
    
fi



touch /root/.mongodb_configured
