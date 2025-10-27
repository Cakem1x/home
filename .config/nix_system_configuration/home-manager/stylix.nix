{ pkgs, ... }:
let
  stylix = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "stylix";
    rev = "...";
    sha256 = "...";
  };
in
{
  imports = [ (import stylix).homeModules.stylix ];

  stylix = {
    enable = true;
    image = ./wallpaper.jpg;
  };
}
