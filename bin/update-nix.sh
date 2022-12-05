#!/usr/bin/env sh

# update global system state
sudo nix-channel --update
sudo nixos-rebuild switch

# update userspace stuff
nix-channel --update
home-manager switch
