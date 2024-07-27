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
    #cura # 3d printing

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
      # city lights theme, via https://github.com/alacritty/alacritty-theme
      colors = {
        primary = {
          background = "0x171d23";
          foreground = "0xffffff";
        };
        cursor = {
          text = "0xfafafa";
          cursor = "0x008b94";
        };
        normal = {
          black = "0x333f4a";
          red = "0xd95468";
          green = "0x8bd49c";
          blue = "0x539afc";
          magenta = "0xb62d65";
          cyan = "0x70e1e8";
          white = "0xb7c5d3";
        };
        bright = {
          black = "0x41505e";
          red = "0xd95468";
          green = "0x8bd49c";
          yellow = "0xebbf83";
          blue = "0x5ec4ff";
          magenta = "0xe27e8d";
          cyan = "0x70e1e8";
          white = "0xffffff";
        };
      };
    };
  };

  # regenerate fonts
  fonts.fontconfig.enable = true;
}
