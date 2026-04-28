FROM ubuntu:26.04@sha256:5e275723f82c67e387ba9e3c24baa0abdcb268917f276a0561c97bef9450d0b4

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  git=1:2.53.0-1ubuntu1 \
  openssh-client=1:10.2p1-2ubuntu3 \
  jq=1.8.1-4ubuntu2 \
  ca-certificates=20260223 \
  curl=8.18.0-1ubuntu2 \
  gnupg=2.4.8-4ubuntu3 \
  lsb-release=12.1-2build1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce=5:29.4.1-1~ubuntu.26.04~resolute \
  docker-ce-cli=5:29.4.1-1~ubuntu.26.04~resolute \
  containerd.io=2.2.3-1~ubuntu.26.04~resolute

COPY known_hosts /root/.ssh/known_hosts

RUN mkdir /root/.docker

RUN mkdir -p /opt/build
COPY run.sh /opt/build/run.sh

WORKDIR /opt/build
ENTRYPOINT ["./run.sh"]
