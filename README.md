Docker containers
===================

**List by subfolders:**

- <span style="color:green">**dbhost**</span> - Ubuntu 16.04, MongoDB 3.6, Mysql 5.7, PHP7.0-cli, snmpd, crons support;

*Sample command:*
```
docker run --name=dbhost -d juozasl/docker:dbhost
````

- <span style="color:green">**mongodb** </span>- Ubuntu 16.04, MongoDB 3.6;

*Sample command:*
```
docker run --name=mongodb -v /db/:/var/lib/mongodb -p 21017:27017 -d juozasl/docker:mongodb
````

- <span style="color:green">**phpapp**</span> - Ubuntu 16.04, Nginx, PHP7.0, php-mongodb.

*Sample command:*
```
docker run --name=phpapp -d juozasl/docker:phpapp
````

- <span style="color:green">**lemp**</span> - Ubuntu 16.04, Nginx, PHP7.0, PHP7.0-cli, Mysql 5.7, php-mongodb, snmpd, cron support.

*Sample command:*
```
docker run --name=lemp -d juozasl/docker:lemp
````

**Automated builds on:**

https://hub.docker.com/r/juozasl/docker/