{ config, pkgs, lib, username, machine_name, ... }:

{
  hardware.graphics.enable32Bit = true;

  programs.gamescope = {
    enable = true;
    capSysNice = false; # Must stay false so Steam's pressure-vessel sandbox can run it
  };

  programs.steam = {
    enable = true; # Sets up the required 32/64-bit FHS environment and GPU driver bindings
  };
}
