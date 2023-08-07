#!/usr/bin/env bash

nix-env -iA \
	nixpkgs.neovim \
	nixpkgs.lazygit

# remove the script itself
rm -f nix_pkgs.sh
