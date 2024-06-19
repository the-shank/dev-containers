#! /bin/bash

set -eu
set -o pipefail

usage() {
	echo "Usage:"
	echo "./update_base.sh <BASE_IMAGENAME> <BASE_DOCKERFILE> <BASE_CONTAINERNAME> [<extra_args>]"
}

# check that we have exactly 3 params
if [ $# -lt 3 ]; then
	usage
	exit 1
fi

DEVC_REPO_DIR=/home/shank/code/misc/dev-container

# params - base
BASE_IMAGENAME=$1
BASE_DOCKERFILE=$2
BASE_CONTAINERNAME=$3

echo "BASE_IMAGENAME:${BASE_IMAGENAME}"
echo "BASE_DOCKERFILE:${BASE_DOCKERFILE}"
echo "BASE_CONTAINERNAME:${BASE_CONTAINERNAME}"

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
	${@:4} \
	--build-arg UID=$(id -u) \
	--build-arg GID=$(id -g) \
	--tag ${BASE_IMAGENAME} \
	--file "$DEVC_REPO_DIR/$BASE_DOCKERFILE" .

# build container
echo ">> [2] creating and running the proj container..."
docker container run \
	-it \
	--label="no-prune" \
	--name ${BASE_CONTAINERNAME} \
	--hostname ${BASE_CONTAINERNAME} \
	--security-opt seccomp=unconfined \
	--cap-add=SYS_PTRACE \
	${DEFAULT_MOUNTS[@]} \
	${DEFAULT_PORTS[@]} \
	${BASE_IMAGENAME}
# --env DISPLAY=$DISPLAY \
