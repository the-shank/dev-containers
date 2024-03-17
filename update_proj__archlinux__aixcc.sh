#! /bin/bash

set -eu
set -o pipefail

# params - base
BASE_IMAGENAME=devc-archlinux-aixcc:base-devel
BASE_DOCKERFILE=Dockerfile.archlinux.aixcc
BASE_CONTAINERNAME=devc-archlinux-aixcc

DEVC_REPO_DIR=/home/shank/code/misc/dev-container
${DEVC_REPO_DIR}/update_base.sh $BASE_IMAGENAME $BASE_DOCKERFILE $BASE_CONTAINERNAME ${@:1}
