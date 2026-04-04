{ config, inputs, modulesPath, username, ... }:

{
  imports = [
    ./modules/common.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    ./modules/niri_desktop.nix
  ];

  # boot and filesystem setup
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdc";
  boot.loader.grub.useOSProber = false;
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" =
    { device = "/dev/mapper/cryptroot";
      fsType = "ext4";
    };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/466eb89d-d1f0-493e-aaf7-1b985e5c5d99";
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/34a131a1-8b1f-4042-8b50-4ed21935f97c";
      fsType = "ext4";
    };

  swapDevices = [{
    device = "/swapfile";
    size = 17 * 1024;
  }];
}
