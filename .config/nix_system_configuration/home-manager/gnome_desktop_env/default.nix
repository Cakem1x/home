{ config, lib, pkgs, ... }:

with lib.hm.gvariant; # easy access for e.g. mkTuple
{

  home.packages = with pkgs; [
    dconf2nix # convert dconf to nix expressions (helps bringing gnome settings to nix cfg)
  ];

  # gnome configuration:
  dconf = {
    enable = true;
    settings = {

      "org/gnome/shell" = {
        # Apparently, extensions need to get installed via system cfg to load properly
        enabled-extensions = [
          "paperwm@paperwm.github.com"
        ];
      };

      "org/gnome/shell/extensions/paperwm/keybindings" = {
        close-window = ["<Shift><Super>q"];
        move-down = ["<Control><Super>Down" "<Shift><Super>j"];
        move-left = ["<Control><Super>comma" "<Shift><Super>comma" "<Control><Super>Left" "<Shift><Super>h"];
        move-monitor-above = ["<Shift><Control><Super>Up" "<Shift><Control><Super>k"];
        move-monitor-below = ["<Shift><Control><Super>Down" "<Shift><Control><Super>j"];
        move-monitor-left = ["<Shift><Control><Super>Left" "<Shift><Control><Super>h"];
        move-monitor-right = ["<Shift><Control><Super>Right" "<Shift><Control><Super>l"];
        move-right = ["<Control><Super>period" "<Shift><Super>period" "<Control><Super>Right" "<Shift><Super>l"];
        move-up = ["<Control><Super>Up" "<Shift><Super>k"];
        new-window = ["<Super>n" "<Shift><Super>Return"];
        switch-down = ["<Super>Down" "<Super>j"];
        switch-left = ["<Super>h" "<Super>Left"];
        switch-monitor-above = ["<Shift><Super>Up" "<Control><Super>k"];
        switch-monitor-below = ["<Shift><Super>Down" "<Control><Super>j"];
        switch-monitor-left = ["<Shift><Super>Left" "<Control><Super>h"];
        switch-monitor-right = ["<Shift><Super>Right" "<Control><Super>l"];
        switch-next = ["<Super>period"];
        switch-previous = ["<Super>comma"];
        switch-right = ["<Super>l" "<Super>Right"];
        switch-up = ["<Super>Up" "<Super>k"];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "alacritty";
        name = "Launch Terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
        rotate-video-lock-static = [];
        screensaver = ["<Control><Alt>l"];
      };

      "org/gnome/desktop/input-sources" = {
        mru-sources = [ (mkTuple [ "xkb" "eu" ]) ];
        show-all-sources = true;
        sources = [ (mkTuple [ "xkb" "us+altgr-weur" ]) (mkTuple [ "xkb" "de" ]) ];
        xkb-options = [ "lv3:ralt_switch" ];
      };
    };
  };

}
