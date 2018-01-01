Docker containers
===================

## dbhost

*Packages:*

Ubuntu 16.04, MongoDB 3.6, Mysql 5.7, PHP7.0-cli, snmpd, crons support;

*Sample command:*
```
docker run --name=dbhost \
    -v /home/mongodb/:/var/lib/mongodb \
    -v /home/mongodb_log/:/var/log/mongodb \
    -v /home/mysql/:/var/lib/mysql \
    -v /home/app/:/var/app \
    -v /home/snmp/:/etc/snmp \
    -v /home/cron/:/etc/cron.d \
    -p 21017:27017 \
    -p 3306:3306 \
    -p 161:161 \
    -d -e 'DB_USER=dbuser' -e 'DB_PASS=dbpass' -e 'DB_NAME=dbname' -e 'MONGODB_USER=dbuser' -e 'MONGODB_PASS=dbpass' juozasl/docker:dbhost
```
*If you will not set 'DB_NAME' then your 'DB_USER' will be granted for all databases (as root).*

*If you will not set 'MONGODB_USER' or 'MONGODB_PASS' your MongoDB server will be accessible without authentification.*

## mongodb

*Packages:*

Ubuntu 16.04, MongoDB 3.6;

*Sample command:*
```
docker run --name=mongodb \
    -v /home/mongodb/:/var/lib/mongodb \
    -v /home/mongodb_log/:/var/log/mongodb \
    -p 21017:27017 \
    -d -e 'MONGODB_USER=dbuser' -e 'MONGODB_PASS=dbpass' juozasl/docker:mongodb
```
*If you will not set 'MONGODB_USER' or 'MONGODB_PASS' your MongoDB server will be accessible without authentification.*

## phpapp

*Packages:*

Ubuntu 16.04, Nginx, PHP7.0, php-mongodb, php-mysql.

*Sample command:*
```
docker run --name=phpapp \
    -v /home/app/:/var/www/app \
    -v /home/log/:/var/www/log \
    -p 80:80 \
    -d juozasl/docker:phpapp
```

## lemp

*Packages:*

Ubuntu 16.04, Nginx, PHP7.0-fpm, PHP7.0-cli, Mysql 5.7, php-mysql, php-mongodb, snmpd, cron support.

*Sample command:*
```
docker run --name=lemp \
    -v /home/mysql/:/var/lib/mysql \
    -v /home/app/:/var/www/app \
    -v /home/log/:/var/www/log \
    -v /home/snmp/:/etc/snmp \
    -v /home/cron/:/etc/cron.d \
    -p 161:161 \
    -p 80:80 \
    -d -e 'DB_USER=dbuser' -e 'DB_PASS=dbpass' -e 'DB_NAME=dbname' juozasl/docker:lemp
```

**Automated builds on:**

https://hub.docker.com/r/juozasl/docker/