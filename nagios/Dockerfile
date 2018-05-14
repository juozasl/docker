# Ubuntu 16.04, Nagios 4.3.4, Nagios-Plugins 2.2.1, Apache2.

FROM ubuntu:16.04

# ++ Supervisor install

RUN apt update && apt install -y supervisor
COPY supervisor/* /etc/supervisor/conf.d/

# ++ nagios server install

RUN apt update && apt install -y \
    wget \
    build-essential \
    apache2 \
    php \
    apache2-mod-php7.0 \
    php-gd \
    libgd-dev \
    sendmail \
    unzip \
    iputils-ping \
    libnet-snmp-perl \
    snmp \
    snmp-mibs-downloader \
    libwww-perl \
    libcrypt-ssleay-perl

RUN useradd nagios && \
    groupadd nagcmd && \
    usermod -a -G nagcmd nagios && \
    usermod -a -G nagios,nagcmd www-data

RUN cd /root/ && \
    wget \ 
    https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.4.tar.gz && \
    tar -xzf nagios*.tar.gz

RUN cd /root/nagios-4.3.4/ && \
    ./configure --with-nagios-group=nagios --with-command-group=nagcmd && \
    make all && \
    make install && \
    make install-commandmode && \
    make install-init && \
    make install-config && \
    /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf && \
    cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/ && \
    chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers

RUN cd /root/ && \
    wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz && \
    tar -xzf nagios-plugins*.tar.gz && \
    cd nagios-plugins-2.2.1/ && \
    ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl && \
    make && \
    make install

RUN cd /root/ && \
    rm *.tar.gz && \
    rm -rf nagios-4.3.4/ && \
    rm -rf nagios-plugins-2.2.1/

# ADD additional plugins
ADD files/check_snmp_extend.sh /usr/local/nagios/libexec/check_snmp_extend.sh
ADD files/check_snmp_load.pl /usr/local/nagios/libexec/check_snmp_load.pl
ADD files/check_snmp_mem.pl /usr/local/nagios/libexec/check_snmp_mem.pl
ADD files/check_snmp_storage.pl /usr/local/nagios/libexec/check_snmp_storage.pl
ADD files/slack_nagios.pl /usr/local/bin/slack_nagios.pl

ADD files/checksupervisor.sh /usr/local/nagios/libexec/checksupervisor.sh

RUN chown nagios:nagios /usr/local/nagios/libexec/*.sh && \
    chown nagios:nagios /usr/local/nagios/libexec/*.pl && \
    chmod 0777 /usr/local/nagios/libexec/*.sh && \
    chmod 0777 /usr/local/nagios/libexec/*.pl

RUN sed -i 's/#cfg_dir=\/usr\/local\/nagios\/etc\/servers/cfg_dir=\/usr\/local\/nagios\/etc\/servers/' /usr/local/nagios/etc/nagios.cfg

RUN mkdir -p /usr/local/nagios/etc/servers

RUN a2enmod rewrite && a2enmod cgi

RUN ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/
ADD files/localhost.cfg /usr/local/nagios/etc/objects/localhost.cfg
ADD files/slack_nagios.cfg /usr/local/nagios/etc/servers/slack_nagios.cfg
RUN cp -r /usr/local/nagios/etc/ /usr/local/nagios/etc1/

RUN rm /var/www/html/index.html
RUN echo "<?php header('Location: nagios/'); exit; ?>" > /var/www/html/index.php

VOLUME /usr/local/nagios/etc/
EXPOSE 80

# ++ run all necessary daemons
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]

