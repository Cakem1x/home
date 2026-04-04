{ config, lib, pkgs, ... }:

{
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
