#!/usr/bin/env bash

readonly IMAGE_NAME='scottg489/docker-build-push:latest'
readonly RUN_TASK=$1
readonly ID_RSA=$2
readonly DOCKER_CONFIG=$3

read -r -d '' JSON_BODY <<- EOM
  {
  "RUN_TASK": "$RUN_TASK",
  "ID_RSA": "$ID_RSA",
  "DOCKER_CONFIG": "$DOCKER_CONFIG",
  "GIT_REPO_URL": "$GIT_REPO_URL",
  "RELATIVE_SUB_DIR": "$RELATIVE_SUB_DIR",
  "DOCKER_IMAGE_NAME": "$DOCKER_IMAGE_NAME"
  }
EOM

curl -v -sS -w '\n%{http_code}' \
  --data-binary "$JSON_BODY" \
  "http://api.conjob.io/job/run?image=$IMAGE_NAME" \
  | tee /tmp/foo \
  | sed '$d' && \
  [ "$(tail -1 /tmp/foo)" -eq 200 ]
