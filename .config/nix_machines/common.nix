# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # fix issues with drivers (bluetooth and wifi)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_NUMERIC="de_DE.UTF-8";
    LC_TIME="de_DE.UTF-8";
    LC_MONETARY="de_DE.UTF-8";
    LC_ADDRESS="de_DE.UTF-8";
    LC_TELEPHONE="de_DE.UTF-8";
    LC_MEASUREMENT="de_DE.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    dpi = 175;
    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = true;
      autoLogin.user = "cakemix";
    };

    layout = "us,de";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    xkbOptions = "grp:win_space_toggle";
    exportConfiguration = true; # fixes localectl

    windowManager.i3.enable = true;
  };

  programs.dconf = {
    enable = true;
  };

  programs.light.enable = true;

  # might help with high dpi scaling
  # environment.variables = {
  #   GDK_SCALE = "1.5";
  #   GDK_DPI_SCALE = "0.666667";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cakemix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    packages = with pkgs; [
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.gnupg.agent = {
    enable = true;
  };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
