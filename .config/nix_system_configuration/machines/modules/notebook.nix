{ config, lib, pkgs, ... }:

{
  # rm light: `brightnessctl` and `hardware.acpilight` offer replacements?
  services.libinput.enable = true; # touchpad support
}
