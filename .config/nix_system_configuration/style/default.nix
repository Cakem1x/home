{ config, lib, pkgs, ... }:

{
    stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
        image = ./wallpapers/nix_rainbow_solarized_light.png;
        targets.alacritty.enable=true;
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
