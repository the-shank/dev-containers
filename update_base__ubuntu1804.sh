#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-ubuntu1804:latest
BASE_DOCKERFILE=Dockerfile.ubuntu1804
BASE_CONTAINERNAME=devc-ubuntu1804

DEVC_REPO_DIR=/home/shank/code/misc/dev-container
${DEVC_REPO_DIR}/update_base.sh $BASE_IMAGENAME $BASE_DOCKERFILE $BASE_CONTAINERNAME ${@:1}
