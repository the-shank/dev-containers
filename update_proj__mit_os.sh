#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-debian:testing
BASE_DOCKERFILE=Dockerfile.debian

# params - proj
PROJ="mit_os"
PROJ_IMAGENAME="devc-$PROJ:debian"
PROJ_DOCKERFILE="Dockerfile.proj_$PROJ"
PROJ_CONTAINERNAME="devc-$PROJ"
PROJ_MOUNTS=()

# default mount volumes
DEFAULT_MOUNTS=(
	"--volume /tmp/.X11-unix:/tmp/.X11-unix"
	"--volume $HOME:/host_home"
	"--volume $HOME/code:/home/shank/code"
	"--volume $HOME/.ssh:/home/shank/.ssh"
)

# stop running devc container
echo ">> [0] stopping (and removing) existing container if any..."
! docker container stop $PROJ_CONTAINERNAME
! docker container rm --force $PROJ_CONTAINERNAME

# update base image
echo ">> [1] updating base image..."
docker image build \
	${@:1} \
	--build-arg UID=$(id -u) --build-arg GID=$(id -g) \
	--tag ${BASE_IMAGENAME} \
	--file ${BASE_DOCKERFILE} .

# update proj image
echo ">> [2] updating proj image..."
docker image build ${@:1} --tag ${PROJ_IMAGENAME} --file ${PROJ_DOCKERFILE} .

# build container
echo ">> [3] creating and running the proj container..."
docker container run \
	-it \
	--label="no-prune" \
	--name ${PROJ_CONTAINERNAME} \
	--hostname ${PROJ_CONTAINERNAME} \
	${DEFAULT_MOUNTS[@]} \
	${PROJ_MOUNTS[@]} \
	--env DISPLAY=$DISPLAY \
	${PROJ_IMAGENAME}
