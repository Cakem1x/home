{ config, pkgs, ... }:

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
    # file viewers
    evince

    # wm, wm system components, UI utils
    i3
    xss-lock
    networkmanagerapplet
    pavucontrol
    playerctl

    # editing
    ispell
    libreoffice
    # latex
    texlive.combined.scheme-full

    # other apps
    firefox
    signal-desktop
    #openscad
    gnucash
    aqbanking
    gnupg
    pinentry
    nextcloud-client
    # unfree
    spotify
  ];
}
