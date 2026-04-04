{
  description = "NixOS system configuration flake";

  inputs = {
    nixos-hardware.url = github:NixOS/nixos-hardware;

    nixpkgs.url = github:nixos/nixpkgs/nixos-25.11;
    home-manager = {
      url = github:nix-community/home-manager/release-25.11;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = github:nix-community/stylix/release-25.11;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # unstable srcs
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager-unstable = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix-unstable = {
      url = github:nix-community/stylix;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
          specialArgs = {
            inherit system inputs;
            username = "cakemix";
            machine_name = "trnstr";
          };
          modules = [
            inputs.stylix.nixosModules.stylix
            ./machines/trnstr.nix
          ];
        };
        charcoal = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system inputs;
            username = "miner";
            machine_name = "charcoal";
          };
          modules = [
            inputs.stylix.nixosModules.stylix
            ./machines/charcoal.nix
          ];
        };
        peptide = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system inputs;
            username = "cakemix";
            machine_name = "peptide";
          };
          modules = [
            inputs.stylix.nixosModules.stylix
            ./machines/peptide.nix
          ];
        };
      };

      homeConfigurations."cakemix"= home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          username = "cakemix";
        };
        modules = [
          inputs.stylix.homeModules.stylix
          ./home-manager/trnstr.nix
        ];
      };
      homeConfigurations."miner"= home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          username = "miner";
        };
        modules = [
          inputs.stylix.homeModules.stylix
          ./home-manager/charcoal.nix
        ];
      };

    };
}
