{ config, lib, pkgs, ... }:

{
  services = {
    # framework firmware update tool
    fwupd.enable = true;
    fwupd.extraRemotes = [ "lvfs-testing" ];
    fwupd.uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;
  };
  
}
