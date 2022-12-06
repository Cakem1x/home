{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      ./common.nix
    ];

  networking.hostName = "trnstr"; # Define your hostname.

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];

  # fix issues with drivers (bluetooth and wifi)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.extraModulePackages = [ ];

  # support dual boot
  boot.loader.grub.useOSProber = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/2042cd58-521b-40cf-8512-c682da50301f";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ac1856a7-8d41-46cf-924f-02c7f2d8efb5";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CCAC-B1B4";
      fsType = "vfat";
    };

  # backlight
  programs.light.enable = true;

  # enable fingerprint reader
  services.fprintd.enable = true;

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = true;

  services.xserver = {
    autorun = true;
    dpi = 175;
    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = true;
      autoLogin.user = "cakemix";
    };
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };
}
