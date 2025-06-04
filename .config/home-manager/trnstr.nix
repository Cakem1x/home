{ config, pkgs, lib, ... }:

let
  # Solarized Light theme, adapted from https://github.com/alacritty/alacritty-theme and doom-solarized-light
  colorscheme = {
    primary = {
      background = "0xfdf6e3";
      foreground = "0x556b72";
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
  wmCfg = {
    modifier = "Mod4";
    wsNames = [
      "1: term"
      "2: www"
      "3: ✎"
      "4"
      "5"
      "6"
      "7"
      "8: ♪"
      "9"
    ];
  };
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
    wdisplays # GUI for display setup

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

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = wmCfg.modifier;
      terminal = "alacritty";
      startup = [ # Programs to run on startup
        {command = "firefox";}
        {command = "alacritty";}
        {command = "emacs";}
        {command = "shikane";} # setup screens
      ];
      input = {
        "*" = {
          xkb_layout = "eu";
        };
      };
      workspaceAutoBackAndForth = true;
      assigns = {
        ${builtins.elemAt wmCfg.wsNames 0} = [{ class = "^Firefox$"; }];
        ${builtins.elemAt wmCfg.wsNames 3} = [{ class = "^emacs"; }];
        ${builtins.elemAt wmCfg.wsNames 8} = [{ class = "^Spotify"; }];
      };
      keybindings = lib.mkOptionDefault (let
        switchBindings = builtins.listToAttrs (lib.imap (i: name: {
          name = "${wmCfg.modifier}+${toString i}";
          value = "workspace ${name}";
        }) wmCfg.wsNames);
        moveBindings = builtins.listToAttrs (lib.imap (i: name: {
          name = "${wmCfg.modifier}+Shift+${toString i}";
          value = "move container to workspace ${name}";
        }) wmCfg.wsNames);
       in
        switchBindings // moveBindings
      );
    };
  };

  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        size = 10;
        normal.family = "Iosevka";
      };

      colors = colorscheme // {
        cursor = {
        text = colorscheme.primary.foreground;
        cursor = colorscheme.normal.blue;
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
