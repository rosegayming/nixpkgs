{ lib
, stdenv
, fetchFromGitHub
, cmake
, libjpeg
, mesa
, pango
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-/Kz4Qy+jx1+bfSq6e2W3MbyODkhs6GqKiiybNtqzvbc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libjpeg
    mesa
    pango
    wayland
    wayland-protocols
  ];

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace GIT_COMMIT_HASH '"${finalAttrs.src.rev}"'
  '';

  preConfigure = ''
    make protocols
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ./hyprpaper -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A blazing fast wayland wallpaper utility";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot fufexan ];
    inherit (wayland.meta) platforms;
  };
})
