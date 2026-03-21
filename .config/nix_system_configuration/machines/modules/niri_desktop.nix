{ config, lib, pkgs, username, ... }:

let default_login_session = "${pkgs.niri}/bin/niri-session";
in {
  xdg.portal = {
    enable = true;
    wlr.enable = true; # xdg-desktop-portal backend for wlroots
  };
  programs.niri.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # enable wayland for chromium and electron based apps

  # login manager
  services.greetd = {
    enable = true;
    settings = {
      initial_session = { # autologin after decrypting hdd
        command = "${default_login_session}";
        user = username;
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --time --cmd ${default_login_session}";
        user = username;
      };
    };
  };

}
