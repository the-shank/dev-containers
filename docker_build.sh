#!/bin/bash

# NOTE:
# $3 can be used to pass in `--no-cache` to create the image from scratch

if [[ $1 == "" ]] || [[ $2 == "" ]]; then
  echo "[!] Usage: docker_build.sh <password> <image_name>"
  exit 1
fi

pass="$1"
image_name="$2"

docker build \
  ${@:3} \
  --build-arg PASSWD="${pass}" \
  --build-arg="UID=$(id -u)" \
  --build-arg="GID=$(id -g)" \
  -t "${image_name}" \
  -f Dockerfile.voidlinux .

# save the image name for future usage
echo "${image_name}" > ./.image_name
