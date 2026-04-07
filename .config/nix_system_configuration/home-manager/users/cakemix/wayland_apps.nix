{ config, lib, pkgs, ... }:

{
    home.packages = with pkgs; [
        supersonic-wayland
        emacs-pgtk # pure gtk for wayland compat
    ];
}
