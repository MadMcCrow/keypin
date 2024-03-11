# Keix:
{ pkgs, lib, python }:
python.pkgs.buildPythonPackage rec {
  version = "2023.9.12";
  pname = "zipapps";
  src = pkgs.fetchFromGitHub {
    owner = "ClericPy";
    repo = "zipapps";
    rev = "de566cb3c4cb97aba3f867e508db1ec211046e96";
    hash = "sha256-88qpwmtaWiZYqqqWpwx5SgxadapKrRxTT4YTNI0B3AE=";
  };
  propagatedBuildInputs = (with python.pkgs; [ ]);
  dontUseSetuptoolsCheck = true;
  meta = {
    mainProgram = "$out/bin/${pname}";
    description = "zipapps is zipapp with dependencies";
  };
}
