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
        size = 8;
        normal.family = "Iosevka";
      };

      # solarized osaka theme, via https://github.com/alacritty/alacritty-theme (source https://github.com/craftzdog/solarized-osaka.nvim)
        colors = {
        primary = {
          background = "0x001a1d";
          foreground = "0x839496";
        };
        cursor = {
          text = "0x839496";  # Not specified, using foreground
          cursor = "0x268bd2";  # Not specified, using normal blue
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
          black = "0x4c4c4c";
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

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
