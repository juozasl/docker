# Ubuntu 14.04, OTRS 4.0.1, Mysql 5.7, snmpd, crons support;
FROM ubuntu:14.04

# ++ Supervisor install
RUN apt update && apt install -y supervisor
COPY supervisor/* /etc/supervisor/conf.d/

# ++ papaildomu paketu instaliavimas
RUN apt update && apt install -y \
    wget 

# ++ Mysql
RUN DEBIAN_FRONTEND=noninteractive apt install -y mysql-server mysql-client
VOLUME /var/lib/mysql
ADD set_mysql_auth.sh /set_mysql_auth.sh

# ++ www server install 
RUN apt update && apt install -y apache2 
EXPOSE 80

# ++ snmpd install
RUN apt update && apt install -y snmpd
RUN echo "rocommunity public 127.0.0.1" > /etc/snmp/snmpd.conf
RUN sed -i 's/snmpd.pid/snmpd.pid -c \/etc\/snmp\/snmpd.conf/' /etc/default/snmpd
VOLUME /etc/snmp/
EXPOSE 161/udp

# ++ crons support
RUN apt update && apt install -y cron run-one
RUN touch /etc/cron.d/app
RUN chmod 0644 /etc/cron.d/app
VOLUME /etc/cron.d/

# ++ OTRS instaliacija
RUN cd /opt/ && \
    wget \ 
    http://ftp.otrs.org/pub/otrs/otrs-4.0.1.tar.gz && \
    tar -xzvf otrs-4.0.1.tar.gz && \
    rm otrs-4.0.1.tar.gz
RUN cd /opt/ && mv otrs-4.0.1 otrs
RUN apt update && apt install -y libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl \
libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libdbd-mysql-perl libsoap-lite-perl \
libgd-text-perl libtext-csv-xs-perl libjson-xs-perl libgd-graph-perl libapache-dbi-perl \
libarchive-zip-perl libcrypt-eksblowfish-perl libdbd-odbc-perl \
libmail-imapclient-perl libtemplate-perl libtemplate-perl libyaml-libyaml-perl
RUN useradd -d /opt/otrs/ -c 'OTRS user' otrs && \
    usermod -G www-data otrs
RUN cd /opt/otrs/ && \
    cp Kernel/Config.pm.dist Kernel/Config.pm && \
    cp Kernel/Config/GenericAgent.pm.dist Kernel/Config/GenericAgent.pm
RUN cd /opt/otrs/ && \
    bin/otrs.SetPermissions.pl --otrs-user=otrs --web-group=www-data /opt/otrs
RUN ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/sites-available/otrs.conf
RUN a2ensite otrs.conf
RUN cd /opt/otrs/var/cron/ && \
    for foo in *.dist; do cp $foo `basename $foo .dist`; done && \
    /opt/otrs/bin/Cron.sh start otrs

# ++ redirect config
RUN echo "<Directory /var/www/html/>" >> /etc/apache2/sites-available/000-default.conf
RUN echo "Options Indexes FollowSymLinks" >> /etc/apache2/sites-available/000-default.conf
RUN echo "AllowOverride All" >> /etc/apache2/sites-available/000-default.conf
RUN echo "Require all granted" >> /etc/apache2/sites-available/000-default.conf
RUN echo "</Directory>" >> /etc/apache2/sites-available/000-default.conf
RUN echo "RedirectMatch ^/$ /otrs/" > /var/www/html/.htaccess

# ++ make copy of init otrs dir
VOLUME /opt/otrs
RUN cd /opt/ && cp -rp otrs/ otrs_init/

# ++ run all necessary daemons
WORKDIR /opt/otrs
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]