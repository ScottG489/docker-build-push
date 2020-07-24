# docker-build-push
![CI](https://github.com/ScottG489/docker-build-push/workflows/CI/badge.svg)

A docker image capable of building and pushing an image in a repo

## Inputs
* A private key which has access to clone your repo
* A docker config.json in order to push to your docker hub
* The git repo url where the Dockerfile exists
* The relative subdir where the Dockerfile exists
* The fully qualified docker image name

## Example usage
To build an image using the docker-ci-prototype (this is building the docker-ci-prototype's build itself):
```bash
ID_RSA_CONTENTS_BASE64=$(base64 id_rsa) ; 
DOCKER_CONFIG_CONTENTS_BASE64=$(base64 config.json) ;
GIT_REPO_URL='git@github.com:ScottG489/docker-ci-prototype.git' ;
RELATIVE_SUB_DIR='util' ;
DOCKER_IMAGE_NAME='scottg489/docker-ci-prototype-build:latest' ;
curl --data-binary '{"ID_RSA": "'"$ID_RSA_CONTENTS_BASE64"'", "DOCKER_CONFIG": "'"$DOCKER_CONFIG_CONTENTS_BASE64"'", "GIT_REPO_URL": "'"$GIT_REPO_URL"'", "RELATIVE_SUB_DIR": "'"$RELATIVE_SUB_DIR"'", "DOCKER_IMAGE_NAME": "'"$DOCKER_IMAGE_NAME"'"}' 'https://<DOCKER CI INSTANCE URL>/build?image=scottg489/docker-build-push:latest'
```
Or to just build an image locally using docker:
```bash
ID_RSA_CONTENTS_BASE64=$(base64 id_rsa) ; 
DOCKER_CONFIG_CONTENTS_BASE64=$(base64 config.json) ;
GIT_REPO_URL='git@github.com:ScottG489/docker-ci-prototype.git' ;
RELATIVE_SUB_DIR='util' ;
DOCKER_IMAGE_NAME='scottg489/docker-ci-prototype-build:latest' ;
docker run -it -v /var/run/docker.sock:/var/run/docker.sock scottg489/docker-build-push:latest '{"ID_RSA": "'"$ID_RSA_CONTENTS_BASE64"'", "DOCKER_CONFIG": "'"$DOCKER_CONFIG_CONTENTS_BASE64"'", "GIT_REPO_URL": "'"$GIT_REPO_URL"'", "RELATIVE_SUB_DIR": "'"$RELATIVE_SUB_DIR"'", "DOCKER_IMAGE_NAME": "'"$DOCKER_IMAGE_NAME"'"}'
```
