{
  description = "Shared options and helpers for the nixos-flake-* category modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      lib = import ./lib { inherit (nixpkgs) lib; };

      nixosModules = rec {
        core = ./nixos/options.nix;
        default = core;
      };
    };
}
