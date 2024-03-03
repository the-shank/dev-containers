#!/bin/bash

# Create a new dev-container based on an existing devc image

set -eu
set -o pipefail

imgtag=$(docker image ls | rg --ignore-case devc | fzf --prompt 'base-image> ' | awk '{printf "%s:%s\n", $1, $2}')
img=$(echo $imgtag | cut -d':' -f1)
tag=$(echo $imgtag | cut -d':' -f2)
echo "selected image: $img:$tag"

read -p "enter project name: " proj
echo "$proj"

# params
BASE_IMAGENAME="$img:$tag"
CONTAINER_NAME="$img-$proj"

# default mount volumes
DEFAULT_MOUNTS=(
	"--volume /tmp/.X11-unix:/tmp/.X11-unix"
	"--volume $HOME:/host_home"
	"--volume $HOME/code:/home/shank/code"
	"--volume $HOME/.ssh:/home/shank/.ssh"
	"--volume /workdisk/shank/:/workdisk/shank/"
	"--volume /run/user/1000/ssh-agent.socket:/tmp/ssh-agent.socket"
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
	--security-opt seccomp=unconfined \
	${@:1} \
	${DEFAULT_MOUNTS[@]} \
	${DEFAULT_PORTS[@]} \
	${BASE_IMAGENAME}
# --env DISPLAY=$DISPLAY \
