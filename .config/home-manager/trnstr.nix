{ config, pkgs, ... }:


let
  nix-alien-pkgs = import (
    builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
in
{
  imports =
    [
      ./common.nix
    ];

  home.packages = with pkgs; [
    # shell basics
    alacritty
    # CLI util
    imagemagick
    pdftk
    xournal
    docker-compose
    # file viewers
    evince
    feh
    ffmpeg
    vlc
    nix-alien-pkgs.nix-alien

    # wm, wm system components, UI utils
    i3
    i3status-rust
    xkb-switch-i3
    xss-lock
    networkmanagerapplet
    pavucontrol
    playerctl

    # editing
    ispell
    libreoffice
    vscode
    # latex
    texlive.combined.scheme-full
    # fonts
    iosevka
    font-awesome # used as symbols in i3bar-rust
    fira-code
    fira-code-symbols

    # other apps
    firefox
    gimp
    signal-desktop
    openscad
    gnucash
    aqbanking
    gnupg
    pinentry
    nextcloud-client
    steam
    cura # 3d printing

    # unfree
    spotify
  ];

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
