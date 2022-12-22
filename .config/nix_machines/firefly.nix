
{ config, pkgs, lib, ... }:

{
  imports = [
    <nixos-hardware/raspberry-pi/4>
    ./common.nix
  ];

  networking.hostName = "firefly";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  # Home Assistant cfg
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "met"
      "radio_browser"
      "backup"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
    openFirewall = true;
  };
}
