{ config, lib, pkgs, inputs, modulesPath, username, ... }:

{
  imports = [
    ./modules/common.nix
    # TODO breaks atm due to qt6 build issue ../style
    inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
    (modulesPath + "/installer/scan/not-detected.nix")
    ./modules/niri_desktop.nix
    ./modules/bluetooth.nix
    ./modules/notebook.nix
    ./modules/docker.nix
    ./modules/vm_stuff.nix
  ];

  boot = {
    kernelModules = [ "kvm-intel" "kvmgt" ];
    kernelParams = [ "intel_iommu=on" ];

    initrd.availableKernelModules =
      [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    loader = {
      # support dual boot
      grub.useOSProber = true;

      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # filesystem setup
  boot.initrd.luks.devices."root".device =
    "/dev/disk/by-uuid/2042cd58-521b-40cf-8512-c682da50301f";
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-root";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/swapfile";
    size = 16384;
  }];

  users.users.${username}.extraGroups = [ "dialout" ]; # access serial devices (e.g. for arduino dev)
}
