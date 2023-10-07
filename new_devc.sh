#!/bin/bash

# Create a new dev-container based on an existing devc image

set -eu
set -o pipefail

img=$(docker image ls | rg --ignore-case devc | fzf --prompt 'base-image> ' | awk '{print $1}')
echo "selected image: $img"

read -p "enter project name: " proj
echo "$proj"

# params
BASE_IMAGENAME=$img
CONTAINER_NAME="$img-$proj"

# default mount volumes
DEFAULT_MOUNTS=(
	"--volume /tmp/.X11-unix:/tmp/.X11-unix"
	"--volume $HOME:/host_home"
	"--volume $HOME/code:/home/shank/code"
	"--volume $HOME/.ssh:/home/shank/.ssh"
	"--volume /workdisk/shank/:/workdisk/shank/"
)

# default published ports
DEFAULT_PORTS=(
	# "--publish 3306:3306"
)

# build container
echo ">> creating container '$CONTAINER_NAME' based on '$BASE_IMAGENAME'..."
docker container run \
	-it \
	--label="no-prune" \
	--name ${CONTAINER_NAME} \
	--hostname ${CONTAINER_NAME} \
	${DEFAULT_MOUNTS[@]} \
	${DEFAULT_PORTS[@]} \
	--env DISPLAY=$DISPLAY \
	${BASE_IMAGENAME}
