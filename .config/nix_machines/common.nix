# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = let
    sops-commit = "855b8d51fc3991bd817978f0f093aa6ae0fae738";
  in [
    "${builtins.fetchTarball {
      url = "https://github.com/Mic92/sops-nix/archive/${sops-commit}.tar.gz";
      # replace this with an actual hash
      sha256 = "1mnnjxf4wrv91kzy0pj2f8pw1vrkaqs3cn4ixix4ghwbx43qvmk2";
    }}/modules/sops"
  ];

  sops = {
    # This will add secrets.yml to the nix store
    # You can avoid this by adding a string to the full path instead, i.e.
    # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
    defaultSopsFile = ./secrets/secrets.yaml;
    # Auto-generate and use age key based on a machines ssh key.
    # Mostly used for decrytping on machines where cfg is deployed.
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["root" "cakemix"];

  networking = {
    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    # true would yield names like wlp3s0 instead of wlan0.
    # wlan0 is easier, bc e.g. i3bar cfgs can use the same string over multiple machines.
    # when having multiple interfaces of the same type on a machine, setting this to true might be important to get reproducable names.
    usePredictableInterfaceNames = false;
    extraHosts =
      ''
        192.168.0.3 firefly
      '';
  };

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
    xkb.layout = "eu";
    exportConfiguration = true; # fixes localectl
  };

  programs.dconf = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    iosevka
    font-awesome # used as symbols in i3bar-rust
    fira-code
    fira-code-symbols
  ];

  security={
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock = {}; # fix swaylock - otherwise, unlocking won't work even with correct password
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  programs.gnupg.agent = {
    enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
