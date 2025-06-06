{ config, pkgs, lib, ... }:

let
  # Solarized Light theme, adapted from https://github.com/alacritty/alacritty-theme and doom-solarized-light
  transformColorForCss = colorWith0xPrefix : "#${builtins.substring 2 6 colorWith0xPrefix}";
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
    fonts = {
      names = [ "Iosevka" "FontAwesome" ];
      size = 8.0;
    };
    wsNames = [
      "1 "
      "2 󰈹"
      "3 ✎"
      "4"
      "5"
      "6"
      "7"
      "8 ♪"
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
    pavucontrol # control sound input and output
    playerctl # control playback (e.g. spotify, vlc)
    swaylock # lock screen

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
  fonts.fontconfig.enable = true; # make fonts available

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true; # enable sway-session.target
    config = {
      modifier = wmCfg.modifier;
      terminal = "alacritty";
      fonts = wmCfg.fonts;
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
      bars = [
        {
          fonts = wmCfg.fonts;
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];

      # sway window styling
      window.hideEdgeBorders = "smart";
      window.border = 3;
      gaps.smartGaps = true;
      gaps.inner = 7;
      colors = {
        unfocused = {
          background = transformColorForCss colorscheme.primary.background;
          border = transformColorForCss colorscheme.primary.foreground;
          childBorder = transformColorForCss colorscheme.primary.background;
          indicator = transformColorForCss colorscheme.primary.foreground;
          text = transformColorForCss colorscheme.primary.foreground;
        };
        focused = {
          background = transformColorForCss colorscheme.normal.blue;
          border = transformColorForCss colorscheme.bright.blue;
          childBorder = transformColorForCss colorscheme.normal.blue;
          indicator = transformColorForCss colorscheme.primary.background;
          text = transformColorForCss colorscheme.primary.background;
        };
        focusedInactive = {
          background = transformColorForCss colorscheme.normal.magenta;
          border = transformColorForCss colorscheme.bright.magenta;
          childBorder = transformColorForCss colorscheme.normal.magenta;
          indicator = transformColorForCss colorscheme.primary.background;
          text = transformColorForCss colorscheme.primary.background;
        };
        urgent = {
          background = transformColorForCss colorscheme.normal.red;
          border = transformColorForCss colorscheme.bright.red;
          childBorder = transformColorForCss colorscheme.normal.red;
          indicator = transformColorForCss colorscheme.primary.background;
          text = transformColorForCss colorscheme.primary.background;
        };
      };

      workspaceAutoBackAndForth = true;
      assigns = {
        ${builtins.elemAt wmCfg.wsNames 1} = [ {app_id = "firefox";} ];
        ${builtins.elemAt wmCfg.wsNames 2} = [ {app_id = "emacs";} ];
        ${builtins.elemAt wmCfg.wsNames 7} = [ { class = "^Spotify";} ];
      };
      keybindings = lib.mkOptionDefault (let
        otherBindings = {
          # Use pactl to adjust volume in PulseAudio.
          XF86AudioRaiseVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          XF86AudioLowerVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          XF86AudioMute = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          XF86AudioMicMute = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          XF86AudioMedia = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          Pause = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          # Brightness keys
          XF86MonBrightnessUp = "exec light -A 10";
          XF86MonBrightnessDown = "exec light -U 10";

          # Media keys
          XF86AudioPrev = "exec playerctl previous";
          XF86AudioPlay = "exec playerctl play-pause";
          XF86AudioNext = "exec playerctl next";
          "${wmCfg.modifier}+m" = ''exec "swaymsg -t get_outputs | ${pkgs.jq}/bin/jq '[.[] | select(.active == true)] | .[(map(.focused) | index(true) + 1) % length].name' |xargs swaymsg move workspace to"'';

          "Mod1+Ctrl+l" = "loginctl lock-session"; # lock screen; Mod1 is alt key
          "Mod4+Shift+r" = "reload";
          "${wmCfg.modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun"; # Run applications
        };
        switchBindings = builtins.listToAttrs (lib.imap (i: name: {
          name = "${wmCfg.modifier}+${toString i}";
          value = "workspace ${name}";
        }) wmCfg.wsNames);
        moveBindings = builtins.listToAttrs (lib.imap (i: name: {
          name = "${wmCfg.modifier}+Shift+${toString i}";
          value = "move container to workspace ${name}";
        }) wmCfg.wsNames);
       in
        switchBindings // moveBindings // otherBindings
      );
    };
  };
  programs.waybar = {
    enable = true;
    style = ''
      /* special state colors */
      @define-color temperature-critical-color ${transformColorForCss colorscheme.normal.red};
      @define-color battery-warning-color ${transformColorForCss colorscheme.normal.yellow};
      @define-color battery-critical-color ${transformColorForCss colorscheme.normal.red};
      @define-color network-disconnected-color ${transformColorForCss colorscheme.normal.red};
      @define-color pulseaudio-muted-color ${transformColorForCss colorscheme.normal.magenta};
      @define-color idle-inhibitor-active-color ${transformColorForCss colorscheme.normal.cyan};

      * {
        font-family: Iosevka;
        font-size: 12px;
        border: none;
        border-radius: 0px;
        min-height: 0;
      }

      window#waybar {
          background-color: transparent;
          color: ${transformColorForCss colorscheme.primary.foreground};
      }

      /* Common module styling with border-bottom */
      #mode, #custom-weather, #custom-playerctl, #clock, #cpu,
      #memory, #temperature, #battery, #network, #pulseaudio, #window,
      #backlight, #disk, #custom-uptime, #custom-updates, #custom-quote,
      #idle_inhibitor, #tray, #custom-temperature, #bluetooth, #workspaces button {
          border: 1px solid;
          padding: 2px;
          margin: 0 2px;
          border-color: ${transformColorForCss colorscheme.primary.foreground};
          background-color: ${transformColorForCss colorscheme.primary.background};
      }

      /* Special styling for specific states */
      #workspaces button.focused {
          background-color: ${transformColorForCss colorscheme.normal.blue};
          color: ${transformColorForCss colorscheme.primary.background};
      }

      #workspaces button.urgent {
          background-color: ${transformColorForCss colorscheme.normal.red};
          color: ${transformColorForCss colorscheme.primary.background};
      }

      #mode {
          background-color: ${transformColorForCss colorscheme.normal.yellow};
          color: ${transformColorForCss colorscheme.primary.background};
      }

      #network.disconnected {
          color: @network-disconnected-color;
          border-bottom-color: @network-disconnected-color;
      }

      #pulseaudio.muted {
          color: @pulseaudio-muted-color;
          border-bottom-color: @pulseaudio-muted-color;
      }

      #disk {
          color: @disk-color;
          border-bottom-color: @disk-color;
      }

      #custom-uptime {
          color: @uptime-color;
          border-bottom-color: @uptime-color;
      }

      #custom-updates {
          color: @updates-color;
          border-bottom-color: @updates-color;
      }

      #custom-quote {
          color: @quote-color;
          border-bottom-color: @quote-color;
      }

      #idle_inhibitor {
          color: @idle-inhibitor-color;
          border-bottom-color: transparent;
      }

      #idle_inhibitor.activated {
          color: @idle-inhibitor-active-color;
          border-bottom-color: @idle-inhibitor-active-color;
      }

      #tray {
          background-color: transparent;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          color: @red;
          border-bottom-color: @red;
      }
    '';

    settings = {
      topBar = {
        layer = "top";
        position = "top";

        modules-left = [
            "sway/workspaces"
            "sway/mode"
        ];
        "sway/mode".format = "{}";

        modules-center = ["sway/window"];

        modules-right = [
            "network"
            "battery"
            "bluetooth"
            "pulseaudio"
            "backlight"
            "custom/temperature"
            "memory"
            "cpu"
            "clock"
            "tray"
          ];
        network = {
          format-wifi = " 󰤨 {essid}";
          format-ethernet = " Wired";
          tooltip-format = "󰅢 {bandwidthDownBytes}";
          format-linked = "󱘖 {ifname} (No IP)";
          format-disconnected = " Disconnected";
          format-alt = "󰤨 {signalStrength}%";
          interval = 1;
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󱐋 {capacity}%";
          interval = 1;
          format-icons = ["󰂎" "󰁼" "󰁿" "󰂁" "󰁹"];
          tooltip = true;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " 󰖁 0%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click-right = "pavucontrol -t 3";
          on-click = "pactl -- set-sink-mute 0 toggle";
          tooltip = true;
          tooltip-format = "Speaker volume {volume}%";
        };
        "custom/temperature" = {
          exec = "${pkgs.lm_sensors}/bin/sensors | awk '/^Package id 0:/ {print int($4)}'";
          format = " {}°C";
          interval = 5;
          tooltip = true;
          tooltip-format = "CPU: {}°C";
        };
        memory = {
          format = "ram {used:0.1f}G/{total:0.1f}G";
          tooltip = true;
          tooltip-format = "RAM {used:0.2f}G/{total:0.2f}G";
        };

        cpu = {
          format = "cpu {usage}%";
          tooltip = true;
        };

        clock = {
          interval = 1;
          timezone = "Europe/Berlin";
          format = " {:%H:%M}";
          tooltip = true;
          tooltip-format = "{:L%Y-%m-%d, %A}";
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          tooltip = true;
          tooltip-format = "Sceen Brightness {percent}%";
          format-icons = ["󰃞" "󰃝" "󰃟" "󰃠"];
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias}{device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
      };
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
