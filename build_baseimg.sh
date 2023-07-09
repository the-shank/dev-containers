#!/bin/bash

# =============================================================
#
# Usage:
# build_baseimg.sh <password> <image_name> <dockerfile> [<other-args for docker build>]
#
# =============================================================
#
# NOTE:
# $4 can be used to pass in `--no-cache` to create the image from scratch

usage() {
  echo "Usage:"
  echo "build_baseimg.sh <password> <image_name> <dockerfile> [<other-args for docker build>]"
}

notes() {
  echo "NOTES:"
  echo "\$4 can be used to pass in '--no-cache' to create the image from scratch"
}

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  usage
  echo ""
  notes
  exit 0
fi

pass="$1"
image_name="$2"
dockerfile="$3"

if [[ $pass == "" ]]; then
  echo "[!] password cannot be empty"
  usage
  exit 1
fi

if [[ $image_name == "" ]]; then
  echo "[!] image_name cannot be empty"
  usage
  exit 1
fi

if [[ $pass == "" ]]; then
  echo "[!] dockerfile needs to be specified"
  usage
  exit 1
fi

docker build \
  "${@:4}" \
  --build-arg PASSWD="${pass}" \
  --build-arg="UID=$(id -u)" \
  --build-arg="GID=$(id -g)" \
  -t "${image_name}" \
  -f "$dockerfile" .
