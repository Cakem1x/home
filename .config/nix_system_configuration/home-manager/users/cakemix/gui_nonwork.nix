{ config, pkgs, lib, ... }:

{
    home.packages = with pkgs; [
        steam # games
        quickemu # virtualization
        signal-desktop-bin
        nextcloud-client # sync nextcloud files
    ];
}
