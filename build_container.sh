#!/bin/bash

# =============================================================
#
# Usage:
# build_container.sh <container_name> <hostname> <image_name>
#
# =============================================================

usage(){
  echo "Usage: "
  echo "build_container.sh <container_name> <image_name> [<other_args>..]"
}

# notes() {
#
# }

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  usage
  # echo ""
  # notes
  exit 0
fi

# Usage:
# ensure_not_empty <val> <msg>
ensure_not_empty() {
  if [[ $1 == "" ]]; then
    echo "${msg} was empty"
    exit 1
  fi
}

container_name=$1
image_name=$2

if [[ $container_name == "" ]]; then
  echo "[!] container_name not provided"
  usage
  exit 1
fi

if [[ $image_name == "" ]]; then
  echo "[!] image_name not provided"
  usage
  exit 1
fi

# hostname same as container_name
hostname="${container_name}"

docker run \
  --label no-prune \
  -it \
  --name "${container_name}" \
  --hostname "${hostname}" \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --volume $HOME:/host_home \
  --volume $HOME/code:/home/shank/code \
  --volume $HOME/.ssh:/home/shank/.ssh \
  --env DISPLAY=$DISPLAY \
  "${@:3}" \
  "$image_name"
