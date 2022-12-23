
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

  hardware.raspberry-pi."4" = {
    fkms-3d.enable = true;
    audio.enable = true;
    pwm0.enable = true;
    i2c0.enable = true;
    i2c1.enable = true;
  };
  users.users.cakemix.extraGroups = ["i2c"];

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
