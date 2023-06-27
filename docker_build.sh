#!/bin/bash

if [[ $1 == "" ]] || [[ $2 == "" ]]; then
  echo "[!] Usage: docker_build.sh <password> <image_name>"
  exit 1
fi

pass="$1"
image_name="$2"

docker build \
  --no-cache \
  --build-arg PASSWD="${pass}" \
  --build-arg="UID=$(id -u)" \
  --build-arg="GID=$(id -g)" \
  -t "${image_name}" \
  -f Dockerfile2204 \
  .

# save the image name for future usage
echo "${image_name}" > ./.image_name
