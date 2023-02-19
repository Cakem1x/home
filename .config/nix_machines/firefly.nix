{ config, pkgs, lib, ... }:

let
  mqttPort = 1883;
  topic_prefix = "h10/floor1/living_room";
  status_topic = "${topic_prefix}/mqtt_on_pi/status";
  bmp280_topic = "${topic_prefix}/bmp280";
  pi_topic = "${topic_prefix}/pi";
in {
  imports = [
    <nixos-hardware/raspberry-pi/4>
    /home/cakemix/devel/pi_local_mqtt_client/service.nix # for local testing
    ./common.nix
  ];

  networking.hostName = "firefly";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root"; # on SSD, connected via USB
      fsType = "ext4";
      options = [ "noatime" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/nix"; # on SSD, connected via USB
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

  # add my local python script for publishing sensor info from the pi via mqtt
  services.pi-local-mqtt-client.enable = true;

  # symlink sops secrets for home assistant to special location where home assistant expects its secrets.
  sops.secrets."home_assistant" = {
    owner = "hass";
    path = "/var/lib/hass/secrets.yaml";
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

      mqtt = {
        sensor = [
          {
            name = "BMP280 Living Room Pressure";
            unit_of_measurement = "hPa";
            device_class = "pressure";
            state_topic = "${bmp280_topic}/pressure";
            availability_topic = status_topic;
          }
          {
            name = "BMP280 Living Room Temperature";
            unit_of_measurement = "°C";
            device_class = "temperature";
            state_topic = "${bmp280_topic}/temperature";
            availability_topic = status_topic;
          }
          {
            name = "Pi CPU Temperature";
            unit_of_measurement = "°C";
            device_class = "temperature";
            state_topic = "${pi_topic}/cpu_temperature";
            availability_topic = status_topic;
          }
        ];
      };
    };
  };
}
