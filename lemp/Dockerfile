# Ubuntu 16.04, Nginx, PHP7.0, PHP7.0-cli, Mysql 5.7, php-mongodb, snmpd, cron support.

FROM ubuntu:16.04

# ++ Supervisor install

RUN apt update && apt install -y supervisor
COPY supervisor/* /etc/supervisor/conf.d/

# ++ install 
RUN apt update && apt install -y nginx php7.0-fpm php7.0-cli php7.0-mysql php7.0-gd php7.0-mcrypt php7.0-mysql php7.0-curl php-mongodb curl

# ++ config
RUN sed -i 's/;cgi.fix_pathinfo/cgi.fix_pathinfo/' /etc/php/7.0/fpm/php.ini
COPY default /etc/nginx/sites-available/default

# ++ volumes
VOLUME /var/www/app/
VOLUME /var/www/log/

# ++ ports
EXPOSE 80


# ++ Mysql 5.7

RUN DEBIAN_FRONTEND=noninteractive apt install -y mysql-server mysql-client

VOLUME /var/lib/mysql
EXPOSE 3306

# ++ snmpd install

RUN apt update && apt install -y snmpd
RUN echo "rocommunity public 127.0.0.1" > /etc/snmp/snmpd.conf
RUN sed -i 's/snmpd.pid/snmpd.pid -c \/etc\/snmp\/snmpd.conf/' /etc/default/snmpd

VOLUME /etc/snmp/
EXPOSE 161/udp

# ++ crons support
RUN apt update && apt install -y cron
RUN touch /etc/cron.d/app
RUN chmod 0644 /etc/cron.d/app

VOLUME /etc/cron.d/

# ++ run all necessary daemons
ADD run.sh /run.sh
CMD ["/run.sh"]

