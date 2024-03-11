# Keix:
{ pkgs, lib, python }:
let
  pyinstaller-hooks-contrib = python.pkgs.buildPythonPackage rec {
    version = "2024.3";
    pname = "pyinstaller-hooks-contrib";
    src = python.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-0YZXwpJnxjVjqWuPx422uprkCvZwKssvjIcd8Sx1tgs=";
    };
    propagatedBuildInputs = (with python.pkgs;[ packaging pip ]);
  };
in
python.pkgs.buildPythonPackage rec {
  version = "6.5.0";
  pname = "pyinstaller";
  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-seVRE8WkDLcEHJCKV/IS8+vT5ETbskXKL5HYanbavsU=";
  };
  propagatedBuildInputs = [ pyinstaller-hooks-contrib ]
    ++ (with python.pkgs;
    [ packaging pip altgraph setuptools pyqt5 pyqt5-stubs qtpy matplotlib ])
    ++ (with pkgs; [ glibc binutils zlib ]); # TODO darwin-binutils

  dontUseSetuptoolsCheck = true;
  meta = {
    mainProgram = "$out/bin/${pname}";
    description = "pyinstaller is a builder for python packages";
  };
}
