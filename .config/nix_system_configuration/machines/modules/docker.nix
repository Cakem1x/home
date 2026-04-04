{ config, lib, pkgs, username, ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon.settings =
      { # fix for WifiOnICE; Moves docker network IP ranges away from what the Deutsche Bahn wifi uses.
        bip = "172.39.1.5/24";
        fixed-cidr = "172.39.1.0/25";
        default-address-pools = [{
          base = "172.39.0.0/16";
          size = 24;
        }];
      };
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
