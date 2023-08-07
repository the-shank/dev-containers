#!/usr/bin/env bash

set -eu
set -o pipefail

# install
curl -L https://nixos.org/nix/install | sh -s -- --yes

# Testing whether Nix is available in subsequent commands
. $HOME/.nix-profile/etc/profile.d/nix.sh
nix --version

# remove the script itself
rm -f nix.sh
