#!/bin/bash

set -e

# CONFIG
HOST=${HOST:-}
USER=${USER:-"test"}
PASS=${PASS:-"test"}

# if not configed already
if [ ! -f /vpn-certs/.config_done ]; then

    if [ -n "${HOST}" ]; then

        # ++ generate authority certs
        cd /vpn-certs/; ipsec pki --gen --type rsa --size 4096 --outform pem > server-root-key.pem; chmod 600 server-root-key.pem

        cd /vpn-certs/; ipsec pki --self --ca --lifetime 3650 --in server-root-key.pem --type rsa --dn "C=US, O=VPN Server, CN=VPN Server Root CA" --outform pem > server-root-ca.pem

        # ++ generate authority certs
        cd /vpn-certs/; ipsec pki --gen --type rsa --size 4096 --outform pem > server-root-key.pem; chmod 600 server-root-key.pem

        cd /vpn-certs/; ipsec pki --self --ca --lifetime 3650 --in server-root-key.pem --type rsa --dn "C=US, O=VPN Server, CN=VPN Server Root CA" --outform pem > server-root-ca.pem

        # ++ generate VPN server certs
        cd /vpn-certs/; ipsec pki --gen --type rsa --size 4096 --outform pem > vpn-server-key.pem

        cd /vpn-certs/; ipsec pki --pub --in vpn-server-key.pem --type rsa | ipsec pki --issue --lifetime 1825 --cacert server-root-ca.pem --cakey server-root-key.pem --dn "C=US, O=VPN Server, CN='${HOST}'" --san '$HOST' --flag serverAuth --flag ikeIntermediate --outform pem > vpn-server-cert.pem

        # ++ copy certs
        cd /vpn-certs/; cp ./vpn-server-cert.pem /etc/ipsec.d/certs/vpn-server-cert.pem
        cd /vpn-certs/; cp ./vpn-server-key.pem /etc/ipsec.d/private/vpn-server-key.pem
        cd /vpn-certs/; chown root /etc/ipsec.d/private/vpn-server-key.pem
        cd /vpn-certs/; chgrp root /etc/ipsec.d/private/vpn-server-key.pem
        cd /vpn-certs/; chmod 600 /etc/ipsec.d/private/vpn-server-key.pem

        # ++ ipseconfig
        sed -i 's/@server_name_or_ip/'${HOST}'/g' /etc/ipsec.conf

        # ++ create user
        echo ${HOST} : RSA \"/etc/ipsec.d/private/vpn-server-key.pem\" |  tee -a /etc/ipsec.secrets
        echo ${USER} %any% : EAP \"${PASS}\" | tee -a /etc/ipsec.secrets

        # ++ config - done
        echo  "done" > /vpn-certs/.config_done


    fi
    
fi

# ++ firewall config
sysctl net.ipv4.ip_forward=1
sysctl net.ipv6.conf.all.forwarding=1
sysctl net.ipv6.conf.eth0.proxy_ndp=1
iptables -t nat -A POSTROUTING -s 10.10.10.10/24 -o eth0 -m policy --dir out --pol ipsec -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.10.10.10/24 -o eth0 -j MASQUERADE

# super visor deamons start
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
