# flake.nix
# the flake responsible for all my systems and apps
{
  description = "keypin a ssh key manager";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs, ... }:
    let
      # multiplatform support
      # only tested on x86_64 linux
      systems = [
        "x86_64-linux"
        "aarch64-linux" # <- not tested
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;

      # import functions:
      imp = module: system:
        (import module rec {
          pkgs = import nixpkgs { inherit system; };
          inherit (nixpkgs) lib;
          flake = self;
        });

    in
    {
      packages = forAllSystems (system: rec {
        keypin = (imp ./nix/keypin.nix system);
        default = keypin;
      });

      # checks for remote compilation
      # TODO : setup checks
      # checks = forAllSystems (system: { demo = demo system; });

      # shell for development
      # TODO : macOS development
      devShells =
        forAllSystems (system: { default = imp ./nix/shell.nix system; });
    };
}
