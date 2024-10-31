#!/bin/bash

# update and existing base image

set -eu
set -o pipefail

DEVC_REPO_DIR=/home/shank/code/misc/dev-container

script=$(find $DEVC_REPO_DIR -type f |
  rg --ignore-case "update_" |
  rg -i --invert-match "devc_new\.sh" |
  rg -i --invert-match "devc_update\.sh" |
  rg -i --invert-match "update_base\.sh" |
  fzf --prompt 'script> ')

(
  cd $DEVC_REPO_DIR
  ${script} ${@:1}
)
