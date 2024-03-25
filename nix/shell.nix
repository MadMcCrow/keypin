# shell environment to develop
{ pkgs, lib, flake ? ./., ... }@args:
let
  python = pkgs.python311;

  # our project
  keypin = import ./keypin.nix args;

  pythonBuild = with python.pkgs; [ build setuptools shiv ];

  # rust is required for commit hooks
in
pkgs.mkShell {
  buildInputs = keypin.nativeBuildInputs ++ pythonBuild ++ [ pkgs.rustup pkgs.rustc pkgs.cargo];
}
