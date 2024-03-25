# Keix:
{ pkgs, lib, flake }:
let
  # shortcut and version setting
  python = pkgs.python310;

  # pyinstaller = import ./pyinstaller.nix { inherit pkgs lib python; };

  libraries = (with python.pkgs; [ rich bcrypt pexpect pyopenssl types-pyopenssl cryptography]);
  # pipModules = ["cryptography"];

  getWheel = lib : lib.overrideAttrs (prev :{
      name = prev.name + "-wheel";
      postBuild = ''
      mkdir -p $out/install/wheels
      find . -iname "*.whl"
      find . -iname "*.whl" -exec cp -r {} $out/install/wheels \;
    '';
  });

  fixed = map (x : getWheel x) libraries;

  # cryptographyWheel = pkgs.stdenvNoCC.mkDerivation {
  #   name = "cryptography-wheel";
  #   src = pkgs.fetchurl {
  #     url = "https://files.pythonhosted.org/packages/6e/8d/6cce88bdeb26b4ec14b23ab9f0c2c7c0bf33ef4904bfa952c5db1749fd37/cryptography-42.0.5-pp310-pypy310_pp73-manylinux_2_28_x86_64.whl";
  #     hash = "sha256-uj5KQjl8Jbf/iM3sbioWwr4Ycg8xdQbuJSEPbTGSX5w=";
  #   };
  #   unpackPhase = "echo \"do nothing\"";
  #   noBuildPhase = true;
  #   installPhase = "install -Dm 755 $src $out/lib/cryptography.whl";
  # };


  # get the libs from the nix store
  mkCopyPythonCmd = pkg: target:
    "cp -r ${pkg}/lib/python${python.pythonVersion}/site-packages/* ${target}";


  mkPipInstall = mod: target: ''
    WHEEL=$(find ${mod} -iname "*.whl")
    echo "${mod} : $WHEEL"
    ${lib.getExe python} -m pip install $WHEEL --target ${target}  --no-index --no-deps
  '';

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

  nativeBuildInputs = [ python python.pkgs.pip ] ++ fixed
    ++ (with pkgs; [ tree ensureNewerSourcesForZipFilesHook]);

  buildPhase = ''
    ${lib.strings.concatLines (map (x: mkPipInstall x name) libraries)}
    ${lib.getExe python} -m zipapp ${name} -c -o ${name}.pyz
  '';

  installPhase = ''
    install -Dm 755 ${name}.pyz $out/lib/${name}.pyz
  '';

  meta = {
    mainProgram = "$out/bin/${name}";
    description = ''
      KeyPin is a script to manage ssh key on machines you have phyisical access to
    '';
  };
}
