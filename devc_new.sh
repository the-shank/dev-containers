#!/bin/bash

# Create a new dev-container based on an existing devc image

set -x
set -eu
set -o pipefail

imgtag=$(podman image ls | rg --ignore-case devc | fzf --prompt 'base-image> ' | awk '{printf "%s:%s\n", $1, $2}')
img=$(echo $imgtag | cut -d':' -f1 | cut -d '/' -f2)
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
  "--volume $SSH_AUTH_SOCK:/tmp/ssh-agent.socket"
  "--volume $XDG_RUNTIME_DIR/podman/podman.sock:/run/podman/podman.sock"
)

if [ -d $HOME/.rustup ]; then
  DEFAULT_MOUNTS+=("--volume $HOME/.rustup:/home/shank/.rustup")
elif [ -d /evaldisk/shank/.rustup ]; then
  DEFAULT_MOUNTS+=("--volume /evaldisk/shank/.rustup:/home/shank/.rustup")
fi

if [ -d $HOME/.cargo ]; then
  DEFAULT_MOUNTS+=("--volume $HOME/.cargo:/home/shank/.cargo")
elif [ -d /evaldisk/shank/.cargo ]; then
  DEFAULT_MOUNTS+=("--volume /evaldisk/shank/.cargo:/home/shank/.cargo")
fi

# if /workdisk exists, then add it to the list of mounts as well
if [ -d /workdisk ]; then
  DEFAULT_MOUNTS+=("--volume /workdisk:/workdisk")
fi

# if /evaldisk exists, then add it to the list of mounts as well
if [ -d /evaldisk ]; then
  DEFAULT_MOUNTS+=("--volume /evaldisk:/evaldisk")
fi

# if both /home/common and /evaldisk/shank exist, then as user which to mount at /home/common
if [ -d /home/common ] && [ -d /evaldisk/shank ]; then
  echo "Mount which to /home/common? (enter 1/2/3)"
  echo "1. /home/common"
  echo "2. /evaldisk/shank"
  echo "3. None"
  read selection
  # ensure that the user enters a valid selection
  if [[ $selection != "1" && $selection != "2" && $selection != "3" ]]; then
    echo "Invalid selection"
    exit 1
  fi
  if [[ $selection == "1" ]]; then
    DEFAULT_MOUNTS+=("--volume /home/common:/home/common")
  elif [[ $selection == "2" ]]; then
    DEFAULT_MOUNTS+=("--volume /evaldisk/shank:/home/common")
  fi

elif [ -d /home/common ]; then
  # if /home/common exists, then add it to the list of mounts as well
  read -p "Mount /home/common to /home/common? (y/n) : " mount_home_common
  if [[ $mount_home_common == "y" || $mount_home_common == "Y" ]]; then
    DEFAULT_MOUNTS+=("--volume /home/common:/home/common")
  fi

elif [ -d /evaldisk/shank ]; then
  # if /evaldisk exists, then add /evaldisk/shank to the list of mounts as well
  read -p "Mount /evaldisk/shank to /home/common? (y/n) : " mount_evaldisk_shank_to_common
  if [[ $mount_evaldisk_shank_to_common == "y" || $mount_evaldisk_shank_to_common == "Y" ]]; then
    DEFAULT_MOUNTS+=("--volume /evaldisk/shank:/home/common")
  fi
fi

# default published ports
DEFAULT_PORTS=(
  # "--publish 3306:3306"
)

# build container
echo ">> creating container '$CONTAINER_NAME' based on '$BASE_IMAGENAME'..."
podman container run \
  -it \
  --label="no-prune" \
  --name ${CONTAINER_NAME} \
  --hostname ${CONTAINER_NAME} \
  --userns=keep-id \
  --security-opt label=disable \
  --security-opt seccomp=unconfined \
  --cap-add=SYS_PTRACE \
  --env CONTAINER_HOST=unix:///run/podman/podman.sock \
  ${@:1} \
  ${DEFAULT_MOUNTS[@]} \
  ${DEFAULT_PORTS[@]} \
  ${BASE_IMAGENAME}
# --env DISPLAY=$DISPLAY \
