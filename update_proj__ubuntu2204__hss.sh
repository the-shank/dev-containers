#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-ubuntu2204-hss:latest
BASE_DOCKERFILE=Dockerfile.ubuntu2204.hss
BASE_CONTAINERNAME=devc-ubuntu2204-hss

DEVC_REPO_DIR=/home/shank/code/misc/dev-container
${DEVC_REPO_DIR}/update_base.sh $BASE_IMAGENAME $BASE_DOCKERFILE $BASE_CONTAINERNAME ${@:1}
