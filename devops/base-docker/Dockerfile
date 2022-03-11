FROM docker:latest

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add curl

RUN apk add bash

RUN apk add git

ADD config.json /root/.docker/

ADD daemon.json /etc/docker/

RUN chmod 0400 /root/.docker/config.json