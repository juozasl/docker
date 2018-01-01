# Ubuntu 16.04, Nagios 4.3.4, Nagios-Plugins 2.2.1, Apache2.

FROM ubuntu:16.04

ENV ADMIN_EMAIL            admin@localhost
ENV NAGIOS_PASS            nagiospassword

# ++ Supervisor install

RUN apt update && apt install -y supervisor
COPY supervisor/* /etc/supervisor/conf.d/

# ++ nagios server install

RUN apt install -y \
    wget \
    build-essential \
    apache2 \
    php \
    apache2-mod-php7.0 \
    php-gd \
    libgd-dev \
    sendmail \
    unzip \
    iputils-ping

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

RUN sed -i 's/#cfg_dir=\/usr\/local\/nagios\/etc\/servers/cfg_dir=\/usr\/local\/nagios\/etc\/servers/' /usr/local/nagios/etc/nagios.cfg

RUN sed -i 's/nagios@localhost/'$ADMIN_EMAIL'/' /usr/local/nagios/etc/objects/contacts.cfg

RUN mkdir -p /usr/local/nagios/etc/servers

RUN a2enmod rewrite && a2enmod cgi

RUN htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin $NAGIOS_PASS 
RUN ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/
ADD localhost.cfg /usr/local/nagios/etc/objects/localhost.cfg
RUN cp -r /usr/local/nagios/etc/ /usr/local/nagios/etc1/

RUN rm /var/www/html/index.html
RUN echo "<?php header('Location: nagios/'); exit; ?>" > /var/www/html/index.php

VOLUME /usr/local/nagios/etc/
EXPOSE 80

# ++ run all necessary daemons
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]

