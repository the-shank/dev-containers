#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-ubuntu1604:latest
BASE_DOCKERFILE=Dockerfile.ubuntu1604
BASE_CONTAINERNAME=devc-ubuntu1604

DEVC_REPO_DIR=/home/shank/code/misc/dev-container
${DEVC_REPO_DIR}/update_base.sh $BASE_IMAGENAME $BASE_DOCKERFILE $BASE_CONTAINERNAME ${@:1}
