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
      alacritty bashInteractive
      # wm
      i3
      # util
      ripgrep fzf exa fd bat unzip pavucontrol
      # fonts
      iosevka

      # dev - other
      git nixfmt shellcheck htop tig
      # dev - C / C++
      gdb clang-tools gcc cmake gnumake
      # dev - python
      python3
      # dev - rust
      rustc cargo

      # editing
      emacs ispell libreoffice

      # other apps
      firefox
      signal-desktop
      openscad
      feh
      imagemagick
      gnucash aqbanking
      gnupg pinentry
      nextcloud-client

      # unfree apps
      spotify
  ];

  programs.fzf = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      TERMINFO_DIRS = "/lib/terminfo";
    };
    shellAliases = {
      home = "git --work-tree=$HOME --git-dir=$HOME/.git_home"; # use "home config status.showUntrackedFiles no" once on new setup
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
    export PATH="$HOME/bin:$PATH"
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

  # regenerate fonts
  fonts.fontconfig.enable = true;

}
