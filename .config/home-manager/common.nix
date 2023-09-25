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
    sops # used via nix-sops for handling secrets in system cfg
    sshfs
    tig
    tree
    udisks # mount disks
    unzip
    usbutils # lsusb
    xclip

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
    python3
    # lang - rust
    rustc
    cargo
    # lang - nix
    nixfmt nixos-option
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

      update-user = "nix-channel --update && home-manager switch";
      update-system = "sudo nix-channel --update && sudo nixos-rebuild switch";
      update-all = "update-system && update-user";
      clean-all = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
    };

    # only for interactive shells
    initExtra = ''
      set -o vi
      # hist
      export HISTFILESIZE=-1
      export HISTSIZE=-1
      export HISTFILE=~/.bash_eternal_history
      export PROMPT_COMMAND="history -a"
      export EDITOR="vim"
      export PATH="$HOME/bin:$HOME/.emacs.d/bin:$PATH"
    '';
  };

  programs.git = {
    delta.enable = true;
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
