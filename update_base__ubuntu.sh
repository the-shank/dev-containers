#! /bin/bash

set -eu
set -o pipefail

# params
BASE=ubuntushank
BASE_DOCKERFILE=Dockerfile.dbox-ubuntu2204
BASE_IMAGENAME=ubuntushank

dbox_base="dbox-${BASE}-base"

# stop any running instance
! distrobox stop $dbox_base

# remove the dbox
! distrobox rm $dbox_base

# build new base image
docker image build --tag ${BASE_IMAGENAME} --file ${BASE_DOCKERFILE} .

# build the distrobox
distrobox-create --image ${BASE_IMAGENAME} --name ${dbox_base} --additional-flags "--label no-prune"

# enter
distrobox-enter -n ${dbox_base}
