# Keix:
{ pkgs, lib, flake, ... }:
let
  # shortcut and version setting
  python = pkgs.python311;
  pythonPackages = pkgs.python311Packages;
in
# zipapp command
pkgs.stdenv.mkDerivation rec {
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

  buildInputs = [ python ]
    ++ (with pythonPackages; [ pip rich cryptography bcrypt pexpect ]);

  nativeBuildInputs = buildInputs
    ++ (with pythonPackages; [ nuitka ])
    ++ (with pkgs; [ ensureNewerSourcesForZipFilesHook ccache ccacheStdenv ]);

  buildPhase = ''
    ${lib.getExe python} -m nuitka ./__main__.py \
    --standalone --onefile \
    --output-filename=${name}.bin
  '';

  installPhase = ''
    mkdir $out/bin -p
    cp ./* $out/bin
  '';

  meta = {
    mainProgram = "$out/bin/${name}";
    description = ''
      KeyPin is a script to manage ssh key on machines you have phyisical access to
    '';
  };
}
