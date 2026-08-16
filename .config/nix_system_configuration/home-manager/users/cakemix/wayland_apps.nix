{ config, lib, pkgs, ... }:

{
    home.packages = with pkgs; [
        supersonic
        emacs-pgtk # pure gtk for wayland compat
    ];
}
