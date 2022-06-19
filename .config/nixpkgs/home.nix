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
    alacritty
    bashInteractive
    # CLI util
    ripgrep
    fzf
    exa
    fd
    bat
    unzip
    imagemagick
    git
    htop
    tig
    # file viewers
    feh
    evince

    # fonts
    iosevka
    fira-code
    fira-code-symbols

    # wm, wm system components, UI utils
    i3
    xss-lock
    networkmanagerapplet
    pavucontrol

    # editing
    emacs
    ispell
    libreoffice
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
    nixfmt

    # other apps
    firefox
    signal-desktop
    openscad
    gnucash
    aqbanking
    gnupg
    pinentry
    nextcloud-client
    # unfree
    spotify
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
      l = "exa";
      ls = "exa";
      la = "exa -la";
      ll = "exa -l";
      lh = "exa -lh";
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
      "lg" = "git log --graph --pretty=oneline --abbrev-commit";
    };
  };

  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        size = 8;
        normal.family = "Fira Code";
      };
      # solarized dark, via https://github.com/eendroroy/alacritty-theme/blob/master/themes/solarized_dark.yaml (Apache license)
      color = {
        primary = {
          background = "0x002b36";
          foreground = "0x839496";
        };
        normal = {
          black = "0x073642";
          red = "0xdc322f";
          green = "0x859900";
          yellow = "0xb58900";
          blue = "0x268bd2";
          magenta = "0xd33682";
          cyan = "0x2aa198";
          white = "0xeee8d5";
        };
        bright = {
          black = "0x002b36";
          red = "0xcb4b16";
          green = "0x586e75";
          yellow = "0x657b83";
          blue = "0x839496";
          magenta = "0x6c71c4";
          cyan = "0x93a1a1";
          white = "0xfdf6e3";
        };
      };
    };
  };

  # regenerate fonts
  fonts.fontconfig.enable = true;

}
