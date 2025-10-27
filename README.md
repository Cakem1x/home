This is my NixOS home on `trnstr`. Contains dotfiles / configuration of the system.
Feel free to have a look around, but be aware that files in this repo are just a bunch of notes for myself.

How to use this repo
=====================
This repo is meant to live directly in `~`.
For convenience, use git alias with special `git-dir`, so other `git` invocations won't find the home repo.
- `alias home="git --work-tree=$HOME --git-dir=$HOME/.git_home"`
- use `"home config status.showUntrackedFiles no"` once on new setup to avoid clutter when doing `home status`.
- Cloning might not work, use `home init` instead. Then, setup upstream: `home remote add origin git@github.com:Cakem1x/home.git`, track branch `home branch --set-upstream-to=origin/main main`, `home pull`

System Setup
============
- Flake-based setup, main flake dir is `.config/nix_system_configuration/`
    - NixOS system configurations are stored in `.config/nix_system_configuration/machines` subdir.
    - The userspace programs (and their configs) are stored in `.config/nix_system_configuration/home-manager`. See https://nix-community.github.io/home-manager/index.html#sec-install-standalone on how to install `home-manager` in standalone mode.
- Editor is doomemacs, which comes via submodule. Run `home submodule init` and `home submodule update`. Finally, run `doom install`.

Managed Machines
===============
- `trnstr`, framework notebook
- `firefly`, rasberry pi 4

Secrets
=======
Secrets are managed via [sops-nix](https://github.com/Mic92/sops-nix).
Use `nix-shell -p ssh-to-age --run 'ssh-keyscan example.com | ssh-to-age' to get public key of new machines to deploy to.
