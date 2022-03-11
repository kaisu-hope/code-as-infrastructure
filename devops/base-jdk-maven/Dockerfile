FROM maven:3.8.4-jdk-8

ADD config.json /root/.docker/

ADD daemon.json /etc/docker/

RUN chmod 0400 /root/.docker/config.json

COPY settings.xml /usr/share/maven/conf