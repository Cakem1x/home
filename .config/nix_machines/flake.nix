{
  description = "NixOS system configuration flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs?ref=nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true; # spotify :/
        };
      };
    in {
      nixosConfigurations = {
        trnstr = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [
            ./trnstr.nix
          ];
        };
      };
    };
}
