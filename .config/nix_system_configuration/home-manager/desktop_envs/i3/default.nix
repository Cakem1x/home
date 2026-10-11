{ config, lib, pkgs, ... }:

let
  colors = {
    background = "#fdf6e3";
    foreground = "#556b72";
    blue = "#268bd2";
    red = "#dc322f";
  };
  lockCommand = "${pkgs.i3lock}/bin/i3lock -n -c 002b36";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  alt = "Mod1";
in
{
  home.packages = with pkgs; [
    autorandr
    dunst
    feh
    flameshot
    font-awesome  # icon font required by i3status-rust "awesome6" icon set
    networkmanagerapplet
    pavucontrol
    picom
    playerctl
    rofi
    xclip
    xrandr
    xss-lock
  ];

  # autorandr: save/restore monitor layouts; auto-applies on hotplug via udev
  programs.autorandr.enable = true;

  services.dunst = {
    enable = true;
    settings.global.default_timeout = 3000;
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "${pkgs.rofi}/bin/rofi -show drun";
      gaps = {
        inner = 6;
        outer = 2;
      };
      window = {
        border = 2;
        commands = [
          { command = "border none"; criteria = { class = "firefox"; }; }
          { command = "floating enable"; criteria = { class = ".qemu-system-x86_64-wrapped"; instance = ".qemu-system-x86_64-wrapped"; }; }
        ];
      };
      startup = [
        { command = "${pkgs.autorandr}/bin/autorandr --change"; always = true; notification = false; }
        { command = "${pkgs.dunst}/bin/dunst"; always = true; notification = false; }
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; always = true; notification = false; }
        { command = "${pkgs.feh}/bin/feh --bg-fill ${pkgs.nixos-artwork.wallpapers.nineish-solarized-light.src}"; always = true; notification = false; }
        { command = "${pkgs.picom}/bin/picom"; always = true; notification = false; }
        { command = "${pkgs.xss-lock}/bin/xss-lock -- ${lockCommand}"; always = true; notification = false; }
        # flameshot daemon must be running before `flameshot gui` keybind works;
        # QT_QPA_PLATFORM=xcb forces X11 backend (avoids Wayland fallback breaking capture)
        { command = "env QT_QPA_PLATFORM=xcb ${pkgs.flameshot}/bin/flameshot"; always = false; notification = false; }
      ];
      bars = [ {
        position = "top";
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config.toml";
        trayOutput = "primary";
        # List both fonts: the monospace for text, Font Awesome for glyphs.
        # i3bar picks the first font that contains the requested glyph.
        fonts = {
          names = [ "Adwaita Mono" "Font Awesome 6 Free" "Font Awesome 6 Brands" ];
          size = 10.0;
        };
        colors = with config.lib.stylix.colors.withHashtag; {
          background = base00;
          statusline = base05;
          separator  = base03;
          focusedWorkspace = {
            border = base05;
            background = base0D;
            text = base00;
          };
          activeWorkspace = {
            border = base03;
            background = base03;
            text = base00;
          };
          inactiveWorkspace = {
            border = base01;
            background = base01;
            text = base05;
          };
          urgentWorkspace = {
            border = base08;
            background = base08;
            text = base00;
          };
          bindingMode = {
            border = base0A;
            background = base0A;
            text = base00;
          };
        };
      } ];
      assigns = {
        "2: www" = [{ class = "firefox"; }];
        "3: doom" = [{ class = "Emacs"; }];
        "8: music" = [{ class = "Spotify"; }];
      };
      keybindings = lib.mkOptionDefault {
        "${config.xsession.windowManager.i3.config.modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${alt}+Ctrl+l" = "exec ${lockCommand}";
        "Print" = "exec --no-startup-id env QT_QPA_PLATFORM=xcb ${pkgs.flameshot}/bin/flameshot gui";
        "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";

        # Brightness
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86MonBrightnessDown" = "exec light -U 10";

        # Floating toggles
        "${alt}+Shift+space" = "floating toggle";
        "${alt}+space" = "focus mode_toggle";

        # Workspaces
        "${config.xsession.windowManager.i3.config.modifier}+1" = "workspace number \"1: term\"";
        "${config.xsession.windowManager.i3.config.modifier}+2" = "workspace number \"2: www\"";
        "${config.xsession.windowManager.i3.config.modifier}+3" = "workspace number \"3: doom\"";
        "${config.xsession.windowManager.i3.config.modifier}+8" = "workspace number \"8: music\"";

        "${config.xsession.windowManager.i3.config.modifier}+Shift+1" = "move container to workspace number \"1: term\"";
        "${config.xsession.windowManager.i3.config.modifier}+Shift+2" = "move container to workspace number \"2: www\"";
        "${config.xsession.windowManager.i3.config.modifier}+Shift+3" = "move container to workspace number \"3: doom\"";
        "${config.xsession.windowManager.i3.config.modifier}+Shift+8" = "move container to workspace number \"8: music\"";

        # Monitors
        "${config.xsession.windowManager.i3.config.modifier}+m" = "move workspace to output next";
      };
    };
  };

  xdg.configFile."i3status-rust/config.toml".text = ''
    [icons]
    icons = "awesome6"
    [theme]
    theme = "solarized-dark"

    [[block]]
    block = "net"
    format = " $icon {$signal_strength $ssid $frequency|Wired connection} via $device ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K) "

    [[block]]
    block = "music"
    format = " $icon {$combo.str(max_w:50,rot_interval:0.5)} "

    [[block]]
    block = "disk_space"
    alert = 10.0
    warning = 50.0

    [[block]]
    block = "memory"
    format = " $icon $mem_used.eng(prefix:M)/$mem_total.eng(prefix:M)"

    [[block]]
    block = "cpu"

    [[block]]
    block = "temperature"
    format = " $icon "
    format_alt = " $icon $average avg, $max max "

    [[block]]
    block = "load"
    format = " {1m} "
    interval = 1

    [[block]]
    block = "sound"
    device_kind = "source" # show mic state

    [[block]]
    block = "sound"
    max_vol = 100
    headphones_indicator = true

    [[block]]
    block = "battery"

    [[block]]
    block = "backlight"
    invert_icons = true

    [[block]]
    block = "time"
    interval = 60
  '';
}
