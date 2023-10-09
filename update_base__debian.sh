#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-debian:testing
BASE_DOCKERFILE=Dockerfile.debian
BASE_CONTAINERNAME=devc-debian

DEVC_REPO_DIR=/home/shank/code/misc/dev-container
${DEVC_REPO_DIR}/update_base.sh $BASE_IMAGENAME $BASE_DOCKERFILE $BASE_CONTAINERNAME ${@:1}
