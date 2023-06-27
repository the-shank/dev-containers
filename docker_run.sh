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
  echo ">> docker_run.sh <container_name> <hostname> [<image_name>]"
  echo ">> if <image_name> is not provided, it defaults to the one in ./.image_name"
  echo "For running existing container:"
  echo ">> docker_run.sh [<container_name>]"
  echo ">> if <container_name> is not provided, it defaults to the one in ./.container_name"
}

# Usage:
# ensure_not_empty <val> <msg>
ensure_not_empty() {
  if [[ $1 == "" ]]; then
    echo "${msg} was empty"
    exit 1
  fi
}

container_name=$1

if [[ $1 == "" ]] || ( [[ $2 == "" ]] && [[ $3 == "" ]] ); then
  # re-running existing container
  if [[ ${container_name} == "" ]]; then
    container_name_from_file=$(cat .container_name)
    if [[ ${container_name_from_file} == "" ]]; then
      echo "[!] no container_name provided and ./.container_name is also empty. Please provide a container name"
      exit 1
    fi
    container_name=${container_name_from_file}
  fi

  docker start -i ${container_name}
  
else
  # creating new container
  hostname=$2
  image_name=$3
  if [[ $image_name == "" ]]; then
    image_name_from_file=$(cat .image_name)
    if [[ $image_name_from_file == "" ]]; then
      echo "[!] no image_name provided and ./.image_name is also empty. Please provide a image_name"
      exit 1
    fi
    image_name=$image_name_from_file
  fi

  echo "${container_name}" > ./.container_name

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
