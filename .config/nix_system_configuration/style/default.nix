{ config, lib, pkgs, ... }:

let
    wallpaperSource = pkgs.fetchFromGitHub {
        owner = "lunik1";
        repo = "nix-wallpaper";
        rev = "f658947fdc9ab85be9003deb26632a464bd41e5d";
        hash = "sha256-WcfoLCZbo32Psw2mP9bF8uHCF50SMAhQFkWq+/+Z9B0=";
    };
    wallpaper = pkgs.callPackage "${wallpaperSource}/pkg" {
        preset = "solarized-light-rainbow";
    };
in
{
    stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
        image = "${wallpaper}/share/wallpapers/nixos-wallpaper.png";
        fonts = {
            serif = {
                package = pkgs.adwaita-fonts;
                name = "Adwaita Serif";
            };

            sansSerif = {
                package = pkgs.adwaita-fonts;
                name = "Adwaita Sans";
            };

            monospace = {
                package = pkgs.adwaita-fonts;
                name = "Adwaita Mono";
            };

        };
    };
}
