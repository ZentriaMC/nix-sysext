{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "reshade-shaders";
  version = "bbc45a4ea6857666b65d43e1c4b4d5628a9aa90f";

  src = fetchFromGitHub {
    owner = "crosire";
    repo = "reshade-shaders";
    rev = version;
    hash = "sha256-oVzfUjlqMbzbEL97mv88sRH1sDRRfGUO+7NuzJLsvAk=";
  };

  dontConfigure = 1;
  dontBuild = 1;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/reshade/shaders $out/share/reshade/textures
    cp Shaders/* $out/share/reshade/shaders/
    cp Textures/* $out/share/reshade/textures/

    runHook postInstall
  '';
}
