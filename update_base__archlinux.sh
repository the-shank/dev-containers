#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-archlinux:base-devel
BASE_DOCKERFILE=Dockerfile.archlinux
BASE_CONTAINERNAME=devc-archlinux

# default mount volumes
DEFAULT_MOUNTS=(
	"--volume /tmp/.X11-unix:/tmp/.X11-unix"
	"--volume $HOME:/host_home"
	"--volume $HOME/code:/home/shank/code"
	"--volume $HOME/.ssh:/home/shank/.ssh"
)

# default published ports
DEFAULT_PORTS=(
	# "--publish 3306:3306"
)

# stop running devc container
echo ">> [0] stopping (and removing) existing container if any..."
! docker container stop $BASE_CONTAINERNAME
! docker container rm --force $BASE_CONTAINERNAME

# update base image
echo ">> [1] updating base image..."
docker image build \
	${@:1} \
	--build-arg UID=$(id -u) --build-arg GID=$(id -g) \
	--tag ${BASE_IMAGENAME} \
	--file ${BASE_DOCKERFILE} .

# build container
echo ">> [2] creating and running the proj container..."
docker container run \
	-it \
	--label="no-prune" \
	--name ${BASE_CONTAINERNAME} \
	--hostname ${BASE_CONTAINERNAME} \
	${DEFAULT_MOUNTS[@]} \
	${DEFAULT_PORTS[@]} \
	--env DISPLAY=$DISPLAY \
	${BASE_IMAGENAME}
