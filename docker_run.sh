#!/bin/bash

# =============================================================
#
# Usage:
#
# For first time container:
# docker_run.sh <container_name> <hostname> <image_name>
# 
# For second time onwards:
# docker_run.sh <container_name>
#
# =============================================================

usage(){
  echo "[!] Usage: "
  echo "For creating and running container:"
  echo ">> docker_run.sh <container_name> <hostname> <image_name>"
  echo "For running existing container:"
  echo ">> docker_run.sh <container_name>"
}

if [[ $1 == "" ]]; then
  usage
  exit 1
fi

container_name=$1

if [[ $2 == "" ]] && [[ $3 == "" ]]; then
  # re-running existing container
  # TODO
  echo "[!] re-running existing container not yet implemented"
  exit 1
  
else
  hostname=$2
  image_name=$3

  docker run \
    --label no-prune \
    -it \
    --name "$container_name" \
    --hostname "$hostname" \
    --volume $HOME:/host_home \
    --volume $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    --env SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    "$image_name"
fi

