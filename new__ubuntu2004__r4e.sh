#! /bin/bash

set -eu
set -o pipefail

# NOTE:
# requires 1 argument

usage() {
	echo "Usage:"
	echo "$0 <new_container_name>"
}

if ! [ "$#" -eq 1 ]; then
	usage
	exit 1
fi

# params
BASE_IMAGENAME=devc-ubuntu2004-r4e:latest
CONTAINER_NAME=$1

# default mount volumes
DEFAULT_MOUNTS=(
	"--volume /tmp/.X11-unix:/tmp/.X11-unix"
	"--volume $HOME:/host_home"
	"--volume $HOME/code:/home/shank/code"
	"--volume $HOME/.ssh:/home/shank/.ssh"
	"--volume /workdisk/shank/:/workdisk/shank/"
)

# build container
echo ">> creating container '$CONTAINER_NAME' based on '$BASE_IMAGENAME'..."
docker container run \
	-it \
	--label="no-prune" \
	--name ${CONTAINER_NAME} \
	--hostname ${CONTAINER_NAME} \
	${DEFAULT_MOUNTS[@]} \
	--env DISPLAY=$DISPLAY \
	${BASE_IMAGENAME}
