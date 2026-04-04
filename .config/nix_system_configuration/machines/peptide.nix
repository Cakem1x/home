{ config, lib, pkgs, inputs, modulesPath, username, ... }:

{
  imports = [
    ./modules/common.nix
    # TODO breaks atm due to qt6 build issue ../style
    inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
    (modulesPath + "/installer/scan/not-detected.nix")
    ./modules/niri_desktop.nix
    ./modules/bluetooth.nix
    ./modules/fwupd.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    initrd.luks.devices."luks-b6d0ae6b-4fd9-4bd8-a1b8-9d673e5255df".device = "/dev/disk/by-uuid/b6d0ae6b-4fd9-4bd8-a1b8-9d673e5255df";
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  # filesystem setup
  fileSystems."/" =
    { device = "/dev/mapper/luks-63038f0e-8a00-4676-a3a5-38dd534908f6";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-63038f0e-8a00-4676-a3a5-38dd534908f6".device = "/dev/disk/by-uuid/63038f0e-8a00-4676-a3a5-38dd534908f6";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2D2E-6B92";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-b6d0ae6b-4fd9-4bd8-a1b8-9d673e5255df"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
