{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;

    # setup stuff via web UI
    overrideDevices = false;
    overrideFolders = false; 
  };
}
