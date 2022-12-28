{ config, pkgs, lib, ... }:

let
  mqttPort = 1883;
in {
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

  services.mosquitto = {
    enable = true;
    listeners = [
      # listener for loopback 127.0.0.1, allows access without auth
      {
        port = mqttPort;
        settings.allow_anonymous = true;
        settings.bind_interface = "lo";
        acl = [ "pattern readwrite #" ];
      }
    ];
  };

  # symlink sops secrets for home assistant to special location where home assistant expects its secrets.
  sops.secrets."home-assistant.yaml" = {
    owner = "hass";
    path = "/var/lib/hass/secret.yaml";
    restartUnits = [ "home-assistant.service" ];
  };
  # Home Assistant cfg
  services.home-assistant = {
    enable = true;
    openFirewall = true;

    extraComponents = [
      "backup"
      "file_upload"
      "met"
      "mqtt"
      "radio_browser"
    ];

    config = {
      default_config = {};

      homeassistant = {
        name = "!secret name";
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        unit_system = "metric";
        country = "DE";
      };

      mqtt = {};
    };
  };
}
