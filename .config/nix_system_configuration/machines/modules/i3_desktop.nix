{ pkgs, username, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.startx = {
      enable = true;
      generateScript = true;
    };
    windowManager.i3.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.greetd = {
    enable = true;
    settings = {
      # Start Xorg as the login user; the generated xinitrc starts i3.
      initial_session = {
        command = "${pkgs.xinit}/bin/startx";
        user = username;
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --time --cmd ${pkgs.xinit}/bin/startx";
        user = username;
      };
    };
  };
}
