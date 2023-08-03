#!/usr/bin/env bash

# set -eu
# set -o pipefail

# install
curl -L https://nixos.org/nix/install | sh -s -- --yes

# update existing shell
# if [ -e '/home/${USER}/.nix-profile/etc/profile.d/nix.fish' ]; then
# 	. '/home/${USER}/.nix-profile/etc/profile.d/nix.fish'
# fi
# if [ -e '/home/${USER}/.nix-profile/etc/profile.d/nix.sh' ]; then
# 	. '/home/${USER}/.nix-profile/etc/profile.d/nix.sh'
# fi

# Testing whether Nix is available in subsequent commands
. $HOME/.nix-profile/etc/profile.d/nix.sh
nix --version

# install apps
# - neovim
# - lazygit
nix-env -iA \
	nixpkgs.neovim \
	nixpkgs.lazygit
