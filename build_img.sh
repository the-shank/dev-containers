#!/bin/bash

# =============================================================
#
# Usage:
# build_img.sh <project_img_name> [<other-args for docker build>]
#
# =============================================================
#
# NOTE:
# $2 can be used to pass in `--no-cache` to create the project image from scratch

usage() {
  echo "Usage:"
  echo "build_img.sh <project_img_name> [<other-args for docker build>]"
}

notes() {
  echo "NOTES:"
  echo "\$2 can be used to pass in '--no-cache' to create the image from scratch"
}

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  usage
  echo ""
  notes
  exit 0
fi

project_img_name="$1"

if [[ $image_name == "" ]]; then
  echo "[!] image_name cannot be empty"
  usage
  exit 1
fi

docker build \
  "${@:2}" \
  -t "${project_img_name}" .
