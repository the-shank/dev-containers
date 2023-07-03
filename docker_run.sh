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
  echo ">> docker_run.sh <container_name> <image_name> [<other_args>..]"
  echo "For running existing container:"
  echo ">> docker_run.sh [<container_name>]"
  echo ">> if <container_name> is not provided, it defaults to the one in ./.container_name"
}

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  usage
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
if [[ $1 == "" ]]; then
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
  hostname="$container_name"

  image_name=$2
  if [[ $image_name == "" ]]; then
    echo "[!] no image_name provided. Please provide a image_name"
    exit 1
  fi

  # echo ">> hostname: $hostname"
  # echo ">> image_name: $image_name"
  # echo ">> container_name: $container_name"

  echo "${container_name}" > ./.container_name

  docker run \
    --label no-prune \
    -it \
    -e DISPLAY \
    --name "$container_name" \
    --hostname "$hostname" \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume $HOME:/host_home \
    --volume $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    --env SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    "${@:3}" \
    "$image_name"
fi
