{ config, flakePath, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    wdisplays # GUI for display setup
    pavucontrol # GUI to control sound input and output
    playerctl # control playback (e.g. spotify, vlc)
    fuzzel # run applications
    mako
    swaylock
    bluetui
    niri
    waybar
    xwayland-satellite
    networkmanagerapplet
    nerd-fonts.symbols-only # used in waybar
  ];

  services.mako.enable = true;
  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;

  fonts.fontconfig.enable = true; # make installed fonts discoverable
}
