{ lib, stdenv, fetchFromGitHub
, cmake
, cunit, ncurses
, curlHTTP3
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V0g/d1B9uMn7KZU6ShzyPGXOSAYCbz4ZubnhAwz+Qsc=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];
  nativeCheckInputs = [ cunit ncurses ];

  cmakeFlags = [
    "-DENABLE_STATIC_LIB=OFF"
  ];

  doCheck = true;
  enableParallelBuilding = true;

  passthru.tests = {
    inherit curlHTTP3;
  };

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/nghttp3";
    description = "nghttp3 is an implementation of HTTP/3 mapping over QUIC and QPACK in C.";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
