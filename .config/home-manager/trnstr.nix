{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./common.nix
      ./desktop_env
    ];

  home.packages = with pkgs; [
    # shell basics
    alacritty

    # CLI util
    imagemagick # do things with images
    ffmpeg # convert/compress videos... and so much more
    pdftk # append / cut pdfs etc.
    docker-compose
    hdparm # check details of disks

    # file viewers
    evince
    feh
    vlc

    # editing
    libreoffice
    vscode

    # latex
    texlive.combined.scheme-full

    # 3D modeling/printing
    openscad # 3D modeling with code
    #cura # 3D printing (currently broken)

    # Keys / Secrets / Auth
    gnupg
    pinentry # handle secrets

    # other apps
    firefox
    gimp
    signal-desktop-bin
    xournalpp # view pdfs & add text/imgs
    nextcloud-client # sync nextcloud files
    steam # games
    nautilus # file manager
    simplescreenrecorder # record my screen (video)
    spotify # music (unfree :( )

    # virtualization
    qemu
    libvirt
  ];
  fonts.fontconfig.enable = true; # make fonts available

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

}
