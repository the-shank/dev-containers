#!/bin/bash

# NOTE:
# $4 can be used to pass in `--no-cache` to create the image from scratch

if [[ $1 == "" ]] || [[ $2 == "" ]]; then
  echo "[!] Usage: docker_build.sh <password> <image_name> <dockerfile> [<other-args for docker build>]"
  exit 1
fi

pass="$1"
image_name="$2"
dockerfile="$3"

docker build \
  "${@:4}" \
  --build-arg PASSWD="${pass}" \
  --build-arg="UID=$(id -u)" \
  --build-arg="GID=$(id -g)" \
  -t "${image_name}" \
  -f "$3" .

# save the image name for future usage
echo "${image_name}" > ./.image_name
