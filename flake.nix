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

      checks.x86_64-linux.default =
        (nixpkgs.lib.nixosSystem {
          modules = [
            self.nixosModules.default
            ({ config, ... }: {
              nixpkgs.hostPlatform = "x86_64-linux";
              boot.loader.grub.enable = false;
              fileSystems."/".fsType = "tmpfs";
              system.stateVersion = config.system.nixos.release;
            })
          ];
        }).config.system.build.toplevel;
    };
}
