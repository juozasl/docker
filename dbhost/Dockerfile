# Ubuntu 16.04, MongoDB 3.6, Mysql 5.7, PHP7.0-cli, snmpd, crons support;

FROM ubuntu:16.04

#ENV DEBIAN_FRONTEND noninteractive

# ++ Mongodb install

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
RUN apt update && apt install -y mongodb-org
VOLUME /var/lib/mongodb
EXPOSE 27017
ADD mongod.conf /etc/mongod.conf

# -- Mysql install



# -- PHP CLI install 

# -- snmpd install

# -- crons support



ADD run.sh /run.sh
CMD ["/run.sh"]
