FROM ubuntu:19.10

RUN apt-get update
RUN apt-get install -y git docker.io jq

RUN mkdir /root/.ssh
COPY known_hosts /root/.ssh/known_hosts

RUN mkdir /root/.docker

RUN mkdir -p /opt/build
COPY run.sh /opt/build/run.sh

WORKDIR /opt/build
ENTRYPOINT ["./run.sh"]
