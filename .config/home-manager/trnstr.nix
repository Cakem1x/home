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
    imagemagick # do things with images
    ffmpeg # convert/compress videos... and so much more
    pdftk # append / cut pdfs etc.
    docker-compose
    hdparm # check details of disks

    # file viewers
    evince
    feh
    vlc

    # wm, wm system components, UI utils
    i3
    i3status-rust
    xkb-switch-i3
    xss-lock
    networkmanagerapplet
    # control audio volume via pulseaudio (via pipewire, actually)
    pavucontrol
    pulseaudio
    # pause/stop/next
    playerctl

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
    flameshot # screenshots
    spotify # music (unfree :( )
    # virtualization
    qemu
    libvirt
  ];

  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        size = 10;
        normal.family = "Iosevka";
      };

      # Ayu Light theme, via https://github.com/alacritty/alacritty-theme (source https://github.com/ayu-theme/ayu-colors)
      colors = {
        primary = {
          background = "0xfcfcfc";
          foreground = "0x5c6166";
        };
        cursor = {
          text = "0x5c6166";
          cursor = "0xeba54d";
        };
        normal = {
          black = "0x010101";
          red = "0xe7666a";
          green = "0x80ab24";
          yellow = "0xeba54d";
          blue = "0x4196df";
          magenta = "0x9870c3";
          cyan = "0x51b891";
          white = "0xc1c1c1";
        };
        bright = {
          black = "0x343434";
          red = "0xee9295";
          green = "0x9fd32f";
          yellow = "0xf0bc7b";
          blue = "0x6daee6";
          magenta = "0xb294d2";
          cyan = "0x75c7a8";
          white = "0xdbdbdb";
        };
      };
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
