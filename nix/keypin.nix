# Keix:
{ pkgs, lib, flake, python ? pkgs.python311 }:
let

  pyinstaller = import ./pyinstaller.nix {inherit pkgs lib python;};

in
pkgs.stdenvNoCC.mkDerivation rec {
  #
  name = "keypin";
  version = "0.1-alpha";

  # filter sources to only true pythonic
  # TODO : simplify this
  src = lib.cleanSourceWith {
    src = flake;
    filter = name: type:
      !(type != "directory" && !(builtins.any (x : lib.strings.hasSuffix x name) [".py" ".md" ".txt"])) && !(type
      == "directory" && builtins.elem (baseNameOf name) [
        "nix"
        ".pytest_cache"
        ".mypy_cache"
        "__pycache__"
      ]);
  };


  nativeBuildInputs = [ python pyinstaller]
    ++ (with python.pkgs; [pip rich bcrypt pexpect pyopenssl types-pyopenssl cryptography])
    ++ (with pkgs; [ glibc tree ensureNewerSourcesForZipFilesHook ]);

  buildPhase = ''
    ${lib.getExe pyinstaller} __main__.py -F --clean -n keypin
  '';

  installPhase = ''
    install -Dm 755 dist/keypin $out/bin/${name}
  '';

  meta = {
    mainProgram = "$out/bin/${name}";
    description = ''
      KeyPin is a script to manage ssh key on machines you have phyisical access to
    '';
  };
}
