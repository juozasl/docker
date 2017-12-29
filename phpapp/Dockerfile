# Ubuntu 16.04, Nginx, PHP7.0, php-mongodb.

FROM ubuntu:16.04

# ++ Supervisor install

RUN apt update && apt install -y supervisor
COPY supervisor/* /etc/supervisor/conf.d/

# ++ install 
RUN apt update && apt install -y nginx php7.0-fpm php7.0-zip php7.0-xmlrpc php7.0-xml php7.0-mysql php7.0-gd php7.0-mcrypt php7.0-mysql php7.0-curl php-mongodb curl

# ++ config
RUN sed -i 's/;cgi.fix_pathinfo/cgi.fix_pathinfo/' /etc/php/7.0/fpm/php.ini
COPY default /etc/nginx/sites-available/default

# ++ volumes
VOLUME /var/www/app/
VOLUME /var/www/log/

# ++ ports
EXPOSE 80

# ++ entry script
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]
