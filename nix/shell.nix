# shell environment to develop
{ pkgs, lib, flake ? ./., ... }@args:
let
  python = pkgs.python311;

  # our project
  keypin = import ./keypin.nix args;

  pyinstaller = import ./pyinstaller.nix { inherit pkgs lib python; };
  zipapps = import ./zipapps.nix { inherit pkgs lib python; };


  pythonBuild = with python.pkgs; [ build setuptools shiv ];

  # rust is required for commit hooks
in
pkgs.mkShell {
  buildInputs = keypin.nativeBuildInputs ++ pythonBuild ++ [ zipapps pyinstaller pkgs.rustup ];
}
