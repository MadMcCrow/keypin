# Keix:
{ pkgs, lib, flake, ... }:
# zipapp command
pkgs.stdenvNoCC.mkDerivation rec {
  #
  name = "keypin";
  version = "0.1-alpha";

  # filter sources to only true pythonic
  src = lib.cleanSourceWith {
    src = flake + "/${name}";
    filter = name: type:
      !(type != "directory" && !lib.strings.hasSuffix ".py" name) && !(type
      == "directory" && builtins.elem (baseNameOf name) [
        "nix"
        ".pytest_cache"
        ".mypy_cache"
        "__pycache__"
      ]);
  };

  buildInputs = [ pkgs.python311 ]
    ++ (with pkgs.python311Packages; [ pip rich cryptography bcrypt pexpect ]);

  nativeBuildInputs = [ pkgs.ensureNewerSourcesForZipFilesHook ] ++ buildInputs;

  buildPhase = ''
    unset SOURCE_DATE_EPOCH
      ${lib.getExe pkgs.python311} -m zipapp $src -o ${name}.pyz -c
      ${lib.getExe pkgs.python311} -m zipapp $src -o ${name}.bin -p '/usr/bin/env python' -c
  '';

  installPhase = ''
    install -m755 -D ./${name}.bin $out/bin/${name}.bin
    install -m755 -D ./${name}.pyz $out/lib/${name}.pyz
    echo "${lib.getExe  pkgs.python311} $out/lib/${name}.pyz" > $out/bin/${name}
  '';
  meta = {
    mainProgram = "$out/bin/${name}";
    description = ''
      KeyPin is a script to manage ssh key on machines you have phyisical access to
    '';
  };
}
