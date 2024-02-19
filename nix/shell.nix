# shell environment to develop
{ pkgs, lib, flake ? ./., ... }@args:
let
  # our project
  keypin = import ./keypin.nix args;

  pythonBuild = with pkgs.python311Packages; [ build setuptools ];

  # rust is required for commit hooks
in
pkgs.mkShell { buildInputs = keypin.buildInputs ++ pythonBuild ++ [ pkgs.rustup ]; }
