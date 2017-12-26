Docker containers
===================

**List by subfolders:**

- **dbhost** - Ubuntu 16.04, MongoDB 3.6, Mysql 5.7, PHP7.0-cli, snmpd, crons support;

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
    -d -e 'DB_USER=dbuser' -e 'DB_PASS=dbpass' -e 'DB_NAME=dbname' juozasl/docker:dbhost
```

- **mongodb** - Ubuntu 16.04, MongoDB 3.6;

*Sample command:*
```
docker run --name=mongodb \
    -v /home/mongodb/:/var/lib/mongodb \
    -v /home/mongodb_log/:/var/log/mongodb \
    -p 21017:27017 \
    -d juozasl/docker:mongodb
```

- **phpapp** - Ubuntu 16.04, Nginx, PHP7.0, php-mongodb.

*Sample command:*
```
docker run --name=phpapp -d juozasl/docker:phpapp
```

- **lemp** - Ubuntu 16.04, Nginx, PHP7.0, PHP7.0-cli, Mysql 5.7, php-mongodb, snmpd, cron support.

*Sample command:*
```
docker run --name=lemp -d juozasl/docker:lemp
```

**Automated builds on:**

https://hub.docker.com/r/juozasl/docker/