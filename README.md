This is my NixOS home on `trnstr`. Contains dotfiles / configuration of the system.
Feel free to have a look around, but be aware that files in this repo are just a bunch of notes for myself.

How to use this repo
=====================
This repo is meant to live directly in `~`.
For convenience, use git alias with special `git-dir`, so other `git` invocations won't find the home repo.
- `alias home="git --work-tree=$HOME --git-dir=$HOME/.git_home"`
- use `"home config status.showUntrackedFiles no"` once on new setup to avoid clutter when doing `home status`.
- Cloning might not work, use `home init` instead. Then, setup upstream, pull.

System Setup
============
- The NixOS system configurations are stored in `.config/nix_machines`. Make them usable via symlink, e.g. `sudo ln -s /home/cakemix/.config/nix_machines/trnstr.nix /etc/nixos/configuration.nix`.
- The userspace programs (and their configs) are managed by home-manager. See https://nix-community.github.io/home-manager/index.html#sec-install-standalone on how to install `home-manager` in standalone mode.
  Relevant files are in `.config/nixpkgs/`. Make file usable via symlink, e.g. `ln -s /home/cakemix/.config/nixpkgs/trnstr.nix /home/cakemix/.config/nixpkgs/home.nix`
- Editor is doomemacs, which comes via submodule -> `home submodule init`! (Do you need to run `doom install` when cfg files come via this repo?)

Managed Machines
===============
- `trnstr`, framework notebook
- `firefly`, rasberry pi 4
