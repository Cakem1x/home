{
  description = "NixOS system configuration flake";

  inputs = {
    #nixpkgs.url = github:nixos/nixpkgs/nixos-25.05;
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    home-manager = {
      #url = github:nix-community/home-manager/release-25.05
      url = github:nix-community/home-manager; # unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
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
            inputs.stylix.nixosModules.stylix
            ./machines/trnstr.nix
          ];
        };
      };

      homeConfigurations."cakemix"= home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.stylix.homeModules.stylix
          ./home-manager/trnstr.nix
        ];
      };

    };
}
