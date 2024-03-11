# Keix:
{ pkgs, lib, flake }:
let
  # shortcut and version setting
  python = pkgs.python311;

  pyinstaller = import ./pyinstaller.nix { inherit pkgs lib python; };

  libraries = (with python.pkgs; [ rich cryptography bcrypt pexpect ]);
  # TODO : make this a function available to other programs

  # get the good stuff
  mkCopyPythonCmd = pkg: target:
    "cp -r ${pkg}/lib/python${python.pythonVersion}/site-packages/* ${target}";

  # zipapp command
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

  buildInputs = [ python pyinstaller ] ++ libraries;

  nativeBuildInputs = [ python ] ++ libraries
    ++ (with pkgs; [ ensureNewerSourcesForZipFilesHook ccache ccacheStdenv ]);

  buildPhase = ''
    ${lib.getExe pyinstaller} __main__.py -F -name ${name}
  '';

  installPhase = ''
    ls -la
    efef
    install -Dm 755 ./${name}.pyz $out/lib/${name}
  '';

  meta = {
    mainProgram = "$out/bin/${name}";
    description = ''
      KeyPin is a script to manage ssh key on machines you have phyisical access to
    '';
  };
}
