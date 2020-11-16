#!/bin/bash
set -e

ID_RSA_CONTENTS=$(echo -n $1 | jq -r .ID_RSA | base64 --decode)
DOCKER_CONFIG_CONTENTS=$(echo -n $1 | jq -r .DOCKER_CONFIG | base64 --decode)

GIT_REPO_URL=$(echo -n $1 | jq -r .GIT_REPO_URL)
RELATIVE_SUB_DIR=$(echo -n $1 | jq -r .RELATIVE_SUB_DIR)
DOCKER_IMAGE_NAME=$(echo -n $1 | jq -r .DOCKER_IMAGE_NAME)

printf -- "$ID_RSA_CONTENTS" > /root/.ssh/id_rsa
printf -- "$DOCKER_CONFIG_CONTENTS" > /root/.docker/config.json

set -x

# Start the docker daemon. This is necessary when using the sysbox-runc container runtime rather than moutning docker.sock
dockerd > /var/log/dockerd.log 2>&1 &
sleep 3

chmod 400 /root/.ssh/id_rsa

git clone $GIT_REPO_URL repo
cd repo/$RELATIVE_SUB_DIR

docker build -t $DOCKER_IMAGE_NAME .
docker push $DOCKER_IMAGE_NAME
