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
	"--volume $HOME/.cargo:/home/shank/.cargo"
	"--volume $HOME/.rustup:/home/shank/.rustup"
	"--volume $SSH_AUTH_SOCK:/tmp/ssh-agent.socket"
)

# if /workdisk exists, then add it to the list of mounts as well
if [ -d /workdisk ]; then
	DEFAULT_MOUNTS+=("--volume /workdisk:/workdisk")
fi

# if /evaldisk exists, then add it to the list of mounts as well
if [ -d /evaldisk ]; then
	DEFAULT_MOUNTS+=("--volume /evaldisk:/evaldisk")
fi

# if /home/common exists, then add it to the list of mounts as well
if [ -d /home/common ]; then
	DEFAULT_MOUNTS+=("--volume /home/common:/home/common")
fi

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
	--cap-add=SYS_PTRACE \
	${@:1} \
	${DEFAULT_MOUNTS[@]} \
	${DEFAULT_PORTS[@]} \
	${BASE_IMAGENAME}
# --env DISPLAY=$DISPLAY \
