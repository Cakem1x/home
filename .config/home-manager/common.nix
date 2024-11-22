{ config, pkgs, ... }:
{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cakemix";
  home.homeDirectory = "/home/cakemix";

  home.packages = with pkgs; [
    # shell basics
    bashInteractive
    # CLI util
    arandr
    autorandr
    bat
    eza
    fd
    findutils
    fzf
    git
    htop
    lazydocker
    ncdu
    ripgrep
    repgrep # rgr (rg based search and replace)
    sops # used via nix-sops for handling secrets in system cfg
    sshfs
    tig
    tree
    udisks # mount disks
    unzip
    usbutils # lsusb
    xclip

    # nix tools
    cachix

    # editing
    vim
    emacs
    helix
    # lang - C / C++
    gdb
    clang-tools
    gcc
    cmake
    gnumake
    # lang - python
    (import ./python-packages.nix { inherit pkgs; })
    # lang - rust
    rustc
    clippy
    cargo
    # lang - nix
    nixfmt-classic nixos-option
    nil
  ];

  programs.fzf = { enable = true; };

  programs.bash = {
    enable = true;
    sessionVariables = { TERMINFO_DIRS = "/lib/terminfo"; };

    shellAliases = {
      home =
        "git --work-tree=$HOME --git-dir=$HOME/.git_home"; # use "home config status.showUntrackedFiles no" once on new setup
      ssh = "TERM=xterm-256color ssh";
      rg = "rg -S";
      e = "emacsclient -n";

      l = "eza";
      ls = "eza";
      la = "eza --git-repos -la";
      ll = "eza --git-repos -l";
      lh = "eza --git-repos -lh";

      os-update-user = "nix-channel --update && home-manager switch";
      os-update-system = "sudo nix-channel --update && sudo nixos-rebuild switch";
      os-update-all = "os-update-system && os-update-user";
      os-clean-all = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
    };

    # only for interactive shells
    initExtra = ''
      # History settings
      # - share common history between shells
      # - remove duplicates
      # according to: https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history/18443#18443
      HISTCONTROL=ignoredups:erasedups
      shopt -s histappend
      PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
      # keep infinite history
      HISTFILESIZE=-1 # inifite history size (bytes)
      HISTSIZE=-1 # inifite history size (lines)
      HISTFILE=~/.bash_eternal_history

      # I like vim
      set -o vi
      export EDITOR="vim"

      # Improve FZF-based shell bindings
      export FZF_DEFAULT_OPTS="-q\ \!/.\ \!^.\ " # ignore dotfiles
      export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200' -q\ \!/.\ \!^.\ " # preview dir contents

      # add my scripts and emacs doom stuff to path
      export PATH="$HOME/bin:$HOME/.emacs.d/bin:$PATH"

      # make work work
      export ROS_DOMAIN_ID=23
      [[ -f "$HOME/nature_robots/devel/dev_tooling/setup/host/setup.bash" ]] && source "$HOME/nature_robots/devel/dev_tooling/setup/host/setup.bash"
    '';
  };
  programs.starship = { # (bash) prompt
    enable = true;
    settings = {
      add_newline = true;
    };
  };

  programs.git = {
    delta = {
      enable = true;
      options = {
        features = "line-numbers";
      };
    };
    enable = true;
    userName = "Matthias Holoch";
    userEmail = "mholoch@gmail.com";
    aliases = {
      "co" = "checkout";
      "st" = "status";
      "lg" = "log --graph --pretty=oneline --abbrev-commit";
    };
  };
}
