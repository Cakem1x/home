{ config, lib, pkgs, ... }:

{
    home.packages = with pkgs; [
        obs-studio # record screen
        kdePackages.kdenlive # cut vids
        emacs
    ];
}
