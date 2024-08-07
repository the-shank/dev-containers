#!/usr/bin/env bash

set -eu
set -o pipefail

. $HOME/.nix-profile/etc/profile.d/nix.sh

nix-env -iA \
  nixpkgs.neovim \
  nixpkgs.lazygit \
  nixpkgs.yazi \
  nixpkgs.just

# remove the script itself
rm -f nix_pkgs.sh
