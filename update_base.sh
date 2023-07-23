#! /bin/bash

set -eu
set -o pipefail

# params
BASE=archshank
BASE_DOCKERFILE=Dockerfile.dbox-archshank
BASE_IMAGENAME=archshank

dbox_base="dbox-${BASE}-base"

# stop any running instance
distrobox stop $dbox_base

# remove the dbox
distrobox rm $dbox_base

# build new base image
docker image build --tag ${BASE_IMAGENAME} --file ${BASE_DOCKERFILE} .

# build the distrobox
distrobox-create --image ${BASE_IMAGENAME} --name ${dbox_base}

# enter
distrobox-enter -n ${dbox_base}
