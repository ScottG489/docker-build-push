FROM ubuntu:24.04

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  git=1:2.43.0-1ubuntu7 \
  openssh-client=1:9.6p1-3ubuntu13 \
  jq=1.7.1-3ubuntu0.24.04.1 \
  ca-certificates=20240203 \
  curl=8.5.0-2ubuntu10.6 \
  gnupg=2.4.4-2ubuntu17.3 \
  lsb-release=12.0-2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce=5:29.1.1-1~ubuntu.24.04~noble \
  docker-ce-cli=5:29.1.1-1~ubuntu.24.04~noble \
  containerd.io=2.2.0-2~ubuntu.24.04~noble

COPY known_hosts /root/.ssh/known_hosts

RUN mkdir /root/.docker

RUN mkdir -p /opt/build
COPY run.sh /opt/build/run.sh

WORKDIR /opt/build
ENTRYPOINT ["./run.sh"]
