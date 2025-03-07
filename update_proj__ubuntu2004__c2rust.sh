#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-ubuntu2004-c2rust:latest
BASE_DOCKERFILE=Dockerfile.ubuntu2004.c2rust
BASE_CONTAINERNAME=devc-ubuntu2004-c2rust

DEVC_REPO_DIR=/home/shank/code/misc/dev-container
${DEVC_REPO_DIR}/update_base.sh $BASE_IMAGENAME $BASE_DOCKERFILE $BASE_CONTAINERNAME ${@:1}
