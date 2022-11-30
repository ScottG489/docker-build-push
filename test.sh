#!/bin/bash
set -ex

declare ID_RSA_CONTENTS_BASE64
declare DOCKER_CONFIG_CONTENTS_BASE64
# Change the location of these files based on where they are on your system
ID_RSA_CONTENTS_BASE64=$(base64 ~/.ssh/id_rsa | tr -d '\n') ;
DOCKER_CONFIG_CONTENTS_BASE64=$(base64 ~/.docker/config.json | tr -d '\n') ;
[[ -n $ID_RSA_CONTENTS_BASE64 ]]
[[ -n $DOCKER_CONFIG_CONTENTS_BASE64 ]]

read -r -d '\' JSON_BODY <<- EOM
  {
  "ID_RSA": "$ID_RSA_CONTENTS_BASE64",
  "DOCKER_CONFIG": "$DOCKER_CONFIG_CONTENTS_BASE64",
  "GIT_REPO_URL": "git@github.com:ScottG489/docker-build-push.git",
  "RELATIVE_SUB_DIR": ".",
  "DOCKER_IMAGE_NAME": "scottg489/docker-build-push:test"
  }\\
EOM

# The local fs is mounted into the container and as such any files it writes will have their permissions changed.
#   This will change the permissions back and clean up other files we don't want hanging around.
sudo chown -R "$(whoami)":"$(whoami)" .

LOCAL_IMAGE_TAG="docker-build-push-build-test-$(uuidgen | cut -c -8)"
docker build . -t "$LOCAL_IMAGE_TAG" && \
docker run -it \
  --runtime=sysbox-runc \
  --volume "$PWD:/opt/build/repo" \
  "$LOCAL_IMAGE_TAG" "$JSON_BODY"
