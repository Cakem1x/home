{ config, pkgs, lib, ... }:

{
    home.packages = with pkgs; [
        # shell basics
        adwaita-fonts
        alacritty

        # CLI util
        imagemagick # do things with images
        ffmpeg # convert/compress videos... and so much more
        pdftk # append / cut pdfs etc.
        docker-compose
        hdparm # check details of disks

        # file viewers
        evince
        feh
        vlc

        # editing
        libreoffice
        vscode

        # latex
        texlive.combined.scheme-full

        # 3D modeling/printing
        openscad # 3D modeling with code
        #cura # 3D printing (currently broken)

        # Keys / Secrets / Auth
        gnupg
        pinentry-gnome3 # handle secrets

        # other apps
        firefox
        xournalpp # view pdfs & add text/imgs
        gimp # edit imgs
        nautilus # file manager
        spotify # music (unfree :( )

        # latex
        texlive.combined.scheme-full
    ];

    fonts.fontconfig.enable = true; # make fonts available

    programs.alacritty.enable = true;
}
