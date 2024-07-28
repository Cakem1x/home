{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      <nixos-hardware/framework/13-inch/11th-gen-intel>
      ./common.nix
    ];

  networking.hostName = "trnstr"; # Define your hostname.

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.extraModulePackages = [ ];

  # support dual boot
  boot.loader.grub.useOSProber = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # filesystem setup
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
  # services.fprintd.enable = true;

  # allows mounting (USB) storage devices more easily
  services.udisks2.enable = true;

  swapDevices = [ { device = "/swapfile"; size = 16384; } ];

  powerManagement.cpuFreqGovernor = "powersave";

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  hardware.bluetooth.enable = true;
  # fix steam
  hardware.graphics.enable32Bit = true;

  services.xserver = {
    enable = true;
    autorun = true;
    windowManager.i3.enable = true;
    # dpi = 175; # adjusted for framework notebook screen, scale other screens with lower res / bigger size via xrandr
    dpi = 150; # adjusted for external screen, but also ok for notebook screen
    # dpi = 100; # adjusted for 1080p external screen
  };
  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin.enable = true;
    autoLogin.user = "cakemix";
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.autorandr.enable = true;

  services.printing.enable = true;
  services.avahi = { # discover network printers
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = { # fix for WifiOnICE; Moves docker network IP ranges away from what the Deutsche Bahn wifi uses.
      bip = "172.39.1.5/24";
      fixed-cidr = "172.39.1.0/25";
      default-address-pools =
      [{
          base= "172.39.0.0/16";
          size= 24;
      }];
    };
  };

  users.users.cakemix.extraGroups = ["docker" "dialout"];
}
