{ config, lib, pkgs, ... }:

let
  # Solarized Light theme, adapted from https://github.com/alacritty/alacritty-theme and doom-solarized-light
  transformColorForCss = colorWith0xPrefix:
    "#${builtins.substring 2 6 colorWith0xPrefix}";
  transformColorForRRGGBB = colorWith0xPrefix:
    "${builtins.substring 2 6 colorWith0xPrefix}";
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
      names = [ "Adwaita" "FontAwesome" ];
      size = 8.0;
    };
    wsNames = [ "1 " "2 󰈹" "3 ✎" "4" "5" "6" "7" "8 ♪" "9" ];
  };

  lockCommand = "${pkgs.swaylock}/bin/swaylock -f -c ${
      transformColorForRRGGBB colorscheme.primary.background
    }";
  pactlBin = "${pkgs.pulseaudio}/bin/pactl";
in {

  home.packages = with pkgs; [
    wdisplays # GUI for display setup
    pavucontrol # control sound input and output
    playerctl # control playback (e.g. spotify, vlc)
    fuzzel # run applications
    # screenshot:
    slurp # pick screens / areas
    satty # annotate pics
    grim # grab wayland screen contents
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    systemd.enable = true; # enable sway-session.target
    config = {
      modifier = wmCfg.modifier;
      terminal = "alacritty";
      fonts = wmCfg.fonts;
      startup = [ # Programs to run on startup
        { command = "firefox"; }
        { command = "alacritty"; }
        { command = "emacs"; }
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet"; }
        { # setup screens
          command = "${pkgs.shikane}/bin/shikane";
          always = true;
        }
        { # setup wallpaper
          command =
            "${pkgs.swaybg}/bin/swaybg -i ${pkgs.nixos-artwork.wallpapers.nineish-solarized-light.src} --mode fill";
          always = true;
        }
      ];
      input = { "*" = { xkb_layout = "eu"; }; };
      bars = [{
        fonts = wmCfg.fonts;
        command = "${pkgs.waybar}/bin/waybar";
      }];

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
        ${builtins.elemAt wmCfg.wsNames 1} = [{ app_id = "firefox"; }];
        ${builtins.elemAt wmCfg.wsNames 2} = [{ app_id = "emacs"; }];
        ${builtins.elemAt wmCfg.wsNames 7} = [{ class = "^Spotify"; }];
      };
      keybindings = lib.mkOptionDefault (let
        otherBindings = {
          # Use pactl to adjust volume in PulseAudio.
          XF86AudioRaiseVolume =
            "exec ${pactlBin} set-sink-volume @DEFAULT_SINK@ +5%";
          XF86AudioLowerVolume =
            "exec ${pactlBin} set-sink-volume @DEFAULT_SINK@ -5%";
          XF86AudioMute = "exec ${pactlBin} set-sink-mute @DEFAULT_SINK@ toggle";
          XF86AudioMicMute =
            "exec ${pactlBin} set-source-mute @DEFAULT_SOURCE@ toggle";
          XF86AudioMedia = "exec ${pactlBin} set-source-mute @DEFAULT_SOURCE@ toggle";
          Pause = "exec ${pactlBin} set-source-mute @DEFAULT_SOURCE@ toggle";

          # screenshot
          Print = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -o -r -c '${transformColorForCss colorscheme.normal.yellow}')" -t ppm - | ${pkgs.satty}/bin/satty --filename - --output-filename $HOME/screenshots/screenshot_$(date '+%y-%m-%d_%H-%M-%S_%N').png'';

          # Brightness keys
          XF86MonBrightnessUp = "exec light -A 10";
          XF86MonBrightnessDown = "exec light -U 10";

          # Media keys
          XF86AudioPrev = "exec playerctl previous";
          XF86AudioPlay = "exec playerctl play-pause";
          XF86AudioNext = "exec playerctl next";

          "${wmCfg.modifier}+m" = ''
            exec "swaymsg -t get_outputs | ${pkgs.jq}/bin/jq '[.[] | select(.active == true)] | .[(map(.focused) | index(true) + 1) % length].name' |xargs swaymsg move workspace to"'';

          "Ctrl+Alt+l" = "exec ${lockCommand}"; # lock screen

          "Mod4+Shift+r" = "reload";
          "${wmCfg.modifier}+d" =
            "exec ${pkgs.fuzzel}/bin/fuzzel"; # Run applications
        };

        switchBindings = builtins.listToAttrs (lib.imap (i: name: {
          name = "${wmCfg.modifier}+${toString i}";
          value = "workspace ${name}";
        }) wmCfg.wsNames);

        moveBindings = builtins.listToAttrs (lib.imap (i: name: {
          name = "${wmCfg.modifier}+Shift+${toString i}";
          value = "move container to workspace ${name}";
        }) wmCfg.wsNames);

      in switchBindings // moveBindings // otherBindings);
    };
  };

  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;
    events = [
      {
        event = "before-sleep";
        command = lockCommand;
      }
      {
        event = "lock";
        command = lockCommand;
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
      {
        timeout = 305;
        command = lockCommand;
      }
    ];
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Adwaita";
      size = 8;
    };
  };

  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        size = 10;
        normal.family = "Adwaita Mono";
      };

      colors = colorscheme // {
        cursor = {
          text = colorscheme.primary.foreground;
          cursor = colorscheme.normal.blue;
        };
      };
    };
  };

  programs.waybar = {
    enable = true;

    settings = {
      topBar = {
        layer = "top";
        position = "top";

        modules-left = [ "sway/workspaces" "sway/mode" ];
        "sway/mode".format = "{}";

        modules-center = [ "sway/window" ];

        modules-right = [
          "idle_inhibitor"
          "network"
          "battery"
          "bluetooth"
          "pulseaudio#output"
          "pulseaudio#input"
          "backlight"
          "memory"
          "cpu"
          "temperature"
          "load"
          "clock#date"
          "clock#time"
          "tray"
        ];

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "sway/window" = {
          max-length = 60;
          all-outputs = true;
        };

        network = {
          format = "{ifname}";
          format-wifi = "{signalStrength}% {essid}";
          format-ethernet = " {ipaddr}/{cidr}";
          format-disconnected = "󰖪";
          tooltip-format = "{bandwidthUpBytes} {bandwidthDownBytes}";
          max-length = 15;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󱐋 {capacity}%";
          interval = 30;
          format-icons = [ "󰂎" "󰁼" "󰁿" "󰂁" "󰁹" ];
          tooltip = true;
        };

        "pulseaudio#input" = {
          format-source = " {volume}%";
          format-source-muted = " off";
          format = "{format_source}";
          max-volume = 100;
          on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          on-scroll-up = "pactl set-source-volume @DEFAULT_SOURCE@ +1%";
          on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -1%";
          on-click-right = "pavucontrol -t 4";
        };
        "pulseaudio#output" = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 off";
          format-icons = { default = [ "" "" "" ]; };
          max-volume = 100;
          on-click = "pactl -- set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pavucontrol -t 3";
        };
        temperature = {
          format = " {temperatureC}°C";
          thermal-zone = 4; # CPU
          critical-threshold = 80;
        };
        memory = {
          format = " {percentage}%";
          tooltip = true;
          tooltip-format = "RAM {used:0.2f}G/{total:0.2f}G";
        };

        cpu = {
          format = " {usage}%";
          tooltip = true;
        };

        load = {
          interval = 1;
          format = "󱤎 {load1}";
          max-length = 10;
        };

        "clock#date" = {
          format = "󰃮 {:%Y-%m-%d}";
          tooltip = true;
          tooltip-format = "{calendar}";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<span><b>{}</b></span>";
              weeks = "<span color='${
                  transformColorForCss colorscheme.normal.yellow
                }'><b>W{}</b></span>";
              weekdays = "<span><b>{}</b></span>";
              today = "<span color='${
                  transformColorForCss colorscheme.normal.blue
                }'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-scroll-forward = "shift_up";
            on-scroll-backward = "shift_down";
          };
        };

        "clock#time" = {
          format = " {:%H:%M}";
          interval = 60;
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          tooltip = true;
          tooltip-format = "Sceen Brightness {percent}%";
          format-icons = [ "󰃞" "󰃝" "󰃟" "󰃠" ];
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery =
            " {device_alias} {device_battery_percentage}%";
          # format-device-preference = [ "device1"; "device2" ]; # preference list deciding the displayed device
          tooltip-format = ''
            {controller_alias}	{controller_address}

            {num_connections} connected'';
          tooltip-format-connected = ''
            {controller_alias}	{controller_address}

            {num_connections} connected

            {device_enumerate}'';
          tooltip-format-enumerate-connected =
            "{device_alias}	{device_address}";
          tooltip-format-enumerate-connected-battery =
            "{device_alias}	{device_address}	{device_battery_percentage}%";
          on-click =
            "bluetoothctl power $(bluetoothctl show | grep -q 'Powered: yes' && echo off || echo on)";
          on-click-right = "alacritty --command ${pkgs.bluetui}/bin/bluetui";
        };

      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0px;
        min-height: 0;
      }

      window#waybar {
        background-color: transparent;
      }

      /* Common module styling */
      .module {
        border: 1px solid;
        padding: 2px;
        margin: 0 2px;
        color: ${transformColorForCss colorscheme.primary.foreground};
        border-color: ${transformColorForCss colorscheme.primary.foreground};
        background-color: ${
          transformColorForCss colorscheme.primary.background
        };
      }

      /* Tooltips */
      tooltip {
        background-color: ${
          transformColorForCss colorscheme.primary.background
        };
        border: 1px solid;
        border-color: ${transformColorForCss colorscheme.primary.foreground};

      }
      tooltip label {
        text-shadow: none;
        color: ${transformColorForCss colorscheme.primary.foreground};
      }

      /* Workspace module styling */
      #workspaces {
        border: none;
        padding: 0px;
        margin: 0px;
      }
      #workspaces .text-button {
        border: 1px solid;
        padding: 2px;
        margin: 0 2px;
        color: ${transformColorForCss colorscheme.primary.foreground};
        border-color: ${transformColorForCss colorscheme.primary.foreground};
        background-color: ${
          transformColorForCss colorscheme.primary.background
        };
      }
      #workspaces button.focused {
        background-color: ${transformColorForCss colorscheme.normal.blue};
        color: ${transformColorForCss colorscheme.primary.background};
      }
      #workspaces button.urgent {
        background-color: ${transformColorForCss colorscheme.normal.red};
        color: ${transformColorForCss colorscheme.primary.background};
      }
      #workspaces button:hover {
        color: ${transformColorForCss colorscheme.normal.blue};
        background-color: ${transformColorForCss colorscheme.normal.blue};
      }

      #mode {
        color: ${transformColorForCss colorscheme.primary.background};
        background-color: ${transformColorForCss colorscheme.normal.yellow};
      }

      #network.disconnected {
        color: ${transformColorForCss colorscheme.primary.background};
        background-color: ${transformColorForCss colorscheme.normal.yellow};
      }

      #idle_inhibitor.activated {
        color: ${transformColorForCss colorscheme.primary.background};
        background-color: ${transformColorForCss colorscheme.normal.blue};
      }

      #tray {
        background-color: transparent;
        border: none;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: ${transformColorForCss colorscheme.normal.red};
      }
    '';
  };
}
