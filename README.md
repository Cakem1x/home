This is my NixOS home on `trnstr`. Contains dotfiles / configuration of the system.
Feel free to have a look around, but note that files in this repo are just a bunch of notes for myself.

How to use this repo
=====================
This repo is meant to live directly in `~`.
For convenience, use git alias with special `git-dir`, so other `git` invocations won't find the home repo.
- `alias home = "git --work-tree=$HOME --git-dir=$HOME/.git_home"`
- use `"home config status.showUntrackedFiles no"` once on new setup to avoid clutter when doing `home status`.

Cloning might not work, use `home init` instead. Then, setup upstream, pull.

System setup
============
- The global NixOS configs are stored in `.config/nix_machines`. Make them usable via symlink, e.g. `sudo ln -s /home/cakemix/.config/nix_machines/trnstr.nix /etc/nixos/configuration.nix`.
- Most things are managed by home-manager anyhow -> install `home-manager`! Relevant files are in `.config/nixpkgs/`.
- Editor is doomemacs, which comes via submodule -> `git submodule init`! (Do you need to run `doom install` when cfg files come via this repo?)
