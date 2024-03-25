# Keix:
{ pkgs, lib, flake, python ? pkgs.python311 }:
let
  # a fixed freezer that won't complain about dates being before 1980 (store is epoch)
  freezer = python.pkgs.cx_Freeze.overrideAttrs (final: prev: {
    postInstall = ''
      substituteInPlace $out/lib/python${python.pythonVersion}/site-packages/cx_Freeze/freezer.py \
      --replace "mtime = int(file_stat.st_mtime) & 0xFFFF_FFFF" "mtime = int(time.time()) & 0xFFFF_FFFF"
    '';
  });

  pymodules = with python.pkgs; [pip rich bcrypt pexpect pyopenssl types-pyopenssl cryptography] ++ [freezer];

in
pkgs.stdenvNoCC.mkDerivation rec {
  #
  name = "keypin";
  version = "0.1-alpha";

  # filter sources to only true pythonic
  src = lib.cleanSourceWith {
    src = flake;
    filter = name: type:
      !(type != "directory" && !lib.strings.hasSuffix ".py" name) && !(type
      == "directory" && builtins.elem (baseNameOf name) [
        "nix"
        ".pytest_cache"
        ".mypy_cache"
        "__pycache__"
      ]);
  };

  buildInputs = [ python ];

  nativeBuildInputs = [python ] ++ pymodules
    ++ (with pkgs; [ tree ensureNewerSourcesForZipFilesHook]);

  buildPhase = "${lib.getExe python} ./setup.py build";

  installPhase = ''
    ls -la
    install -Dm 755 ${name}.pyz $out/lib/${name}.pyz
  '';

  meta = {
    mainProgram = "$out/bin/${name}";
    description = ''
      KeyPin is a script to manage ssh key on machines you have phyisical access to
    '';
  };
}
