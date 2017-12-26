#Ubuntu 16.04, MongoDB 3.6;

FROM ubuntu:16.04

#ENV DEBIAN_FRONTEND noninteractive

# ++ Supervisor install

RUN apt update && apt install -y supervisor
COPY supervisor/* /etc/supervisor/conf.d/

# ++ mongodb install

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list

RUN apt update && apt install -y mongodb-org
RUN sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

VOLUME /var/log/mongodb
VOLUME /var/lib/mongodb

EXPOSE 27017

ADD run.sh /run.sh

CMD ["/run.sh"]
