{ config, lib, pkgs, modulesPath, ... }:

let
  default_login_session = "${pkgs.sway}/bin/sway";
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      <nixos-hardware/framework/13-inch/11th-gen-intel>
      ./common.nix
    ];

  networking.hostName = "trnstr"; # Define your hostname.
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  boot = {
    kernelModules = [ "kvm-intel" "kvmgt" ];
    kernelParams = [ "intel_iommu=on" ];


    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    loader = {
      # support dual boot
      grub.useOSProber = true;

      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # filesystem setup
  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/2042cd58-521b-40cf-8512-c682da50301f";
  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  programs.light.enable = true; # backlight
  swapDevices = [ { device = "/swapfile"; size = 16384; } ];
  powerManagement.cpuFreqGovernor = "powersave";
  hardware = {
    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    bluetooth.enable = true;
    # fix steam
    graphics.enable32Bit = true;
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true; # xdg-desktop-portal backend for wlroots
    extraPortals = [pkgs.xdg-desktop-portal-gtk]; # make gtk apps happy
  };

  services = {
    fwupd.enable = true; # firmware update tool
    fwupd.extraRemotes = [ "lvfs-testing" ];
    fwupd.uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;

    # login manager
    greetd = {
      enable = true;
      settings = {
        initial_session = { # autologin after decrypting hdd
          command = "${default_login_session}";
          user = "cakemix";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${default_login_session}";
          user = "greeter";
        };
      };
    };

    libinput.enable = true; # touchpad support
    udisks2.enable = true;  # allows mounting (USB) storage devices more easily
    autorandr.enable = true; # automatically restore xrandr configurations, based on detected screens
    printing.enable = true;
    avahi = { # discover network printers
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    gvfs.enable = true; # dbus daemon that enables mounting samba shares via file managers like Nautilus
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

  # VM stuff
  # ToDo/Notes: for better GPU performance in my VM, look into SR-IOV support. Apparently, Tigerlake does not support GVT-g anymore. However, SR-IOV support on Linux seems to be bad since it is very new
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  users.users.cakemix.extraGroups = ["docker" "dialout" "libvirtd" "kvm"];

}
