{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_6_12; # latest stable has issues with legacy_580 driver (kernel panic on boot)

  # Early KMS: load the nvidia DRM stack in the initrd so /dev/dri/card0 exists before greetd
  # starts the autologin niri session. Without this, niri races the module load from stage 2
  # and dies with "couldn't find a GPU".
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580; # using latest stable version (default) produces error from Kernel. Error msg tells me that my GPU is supported through this legacy package.
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = false;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
