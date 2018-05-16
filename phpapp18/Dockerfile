# Ubuntu 18.04, Nginx, PHP7.2, php-mongodb.

FROM ubuntu:18.04

# ++ Supervisor install

RUN apt update && apt install -y supervisor
COPY supervisor/* /etc/supervisor/conf.d/

# ++ install 
RUN apt update && apt install -y nginx php-fpm php-zip php-xmlrpc php-xml php-mysql php-gd php-mbstring php-curl php-mongodb curl

# ++ config
RUN sed -i 's/;cgi.fix_pathinfo/cgi.fix_pathinfo/' /etc/php/7.2/fpm/php.ini
COPY default_yii2 /etc/nginx/sites-available/default_yii2
COPY default_laravel /etc/nginx/sites-available/default_laravel

# ++ volumes
VOLUME /var/www/app/
VOLUME /var/www/log/

# ++ ports
EXPOSE 80

# ++ snmpd install

RUN apt update && apt install -y snmpd
RUN echo "rocommunity public 127.0.0.1" > /etc/snmp/snmpd.conf
RUN sed -i 's/snmpd.pid/snmpd.pid -c \/etc\/snmp\/snmpd.conf/' /etc/default/snmpd

ADD files/checksupervisor.sh /usr/local/bin/checksupervisor.sh

VOLUME /etc/snmp/
EXPOSE 161/udp

WORKDIR /var/www/app

# ++ entry script
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]
