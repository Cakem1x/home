{ config, lib, pkgs, ... }:

{
  programs.light.enable = true; # backlight
  services.libinput.enable = true; # touchpad support
}
