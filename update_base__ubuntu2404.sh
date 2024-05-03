#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-ubuntu2404:latest
BASE_DOCKERFILE=Dockerfile.ubuntu2404
BASE_CONTAINERNAME=devc-ubuntu2404

DEVC_REPO_DIR=/home/shank/code/misc/dev-container
${DEVC_REPO_DIR}/update_base.sh $BASE_IMAGENAME $BASE_DOCKERFILE $BASE_CONTAINERNAME ${@:1}
