{ config, lib, pkgs, username, ... }:

{
  # VM stuff
  # ToDo/Notes: for better GPU performance in my VM, look into SR-IOV support. Apparently, Tigerlake does not support GVT-g anymore. However, SR-IOV support on Linux seems to be bad since it is very new
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  users.users.${username}.extraGroups = [ "libvirtd" ];
}
