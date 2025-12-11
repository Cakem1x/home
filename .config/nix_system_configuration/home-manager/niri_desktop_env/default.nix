{ config, flakePath, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    wdisplays # GUI for display setup
   # pavucontrol # control sound input and output
    playerctl # control playback (e.g. spotify, vlc)
    fuzzel # run applications
    mako
    swaylock
    niri
  ];

  programs.waybar.enable = true;
  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
}
