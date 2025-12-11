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

    #nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    #home-manager = {
    #  url = github:nix-community/home-manager;
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #stylix = {
    #  url = github:nix-community/stylix;
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
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
