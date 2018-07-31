# Ubuntu 16.04, strongswan;
FROM ubuntu:16.04

# ++ Supervisor install
RUN apt update && apt install -y supervisor
COPY supervisor/* /etc/supervisor/conf.d/

# ++ packages install
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y \
    -o Dpkg::Options::="--force-confdef" -o \
    Dpkg::Options::="--force-confold" install \
    strongswan \
    strongswan-plugin-eap-mschapv2 \
    moreutils \
    iptables \
    iputils-ping \
    mc

# ++ make certificates dirs
RUN mkdir -p /vpn-certs/
WORKDIR /vpn-certs/
VOLUME /vpn-certs

# ++ copy ipsec config
COPY files/ipsec_template.conf /etc/ipsec_template.conf
RUN chmod 644 /etc/ipsec_template.conf
RUN chown root:root /etc/ipsec_template.conf

# ++ expose ports
EXPOSE 500/udp
EXPOSE 4500/udp

# ++ run all necessary daemons
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]