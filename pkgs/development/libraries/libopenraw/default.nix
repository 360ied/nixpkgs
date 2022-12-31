{ lib, stdenv, fetchzip, boost, libjpeg, pkg-config, libxml2, cargo, rustc
, rustPlatform }:

stdenv.mkDerivation rec {
  pname = "libopenraw";
  version = "0.3.3";

  src = fetchzip {
    url =
      "https://libopenraw.freedesktop.org/download/libopenraw-${version}.tar.xz";
    sha256 = "sha256-dPTlFRH7zluB6FknSqhwzcfOEUKjQGeGDrKkC60xgKU=";
  };

  nativeBuildInputs = [ pkg-config cargo rustc ];
  buildInputs = [ boost libjpeg libxml2 ];
  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; }
    ++ rustPlatform.importCargoLock { lockFile = "${src}/lib/mp4/Cargo.lock"; };

  postPatch = ''
    cp ${./Cargo.lock} lib/mp4/mp4parse_capi/Cargo.lock
  '';

  meta = with lib; {
    homepage = "https://libopenraw.freedesktop.org/libopenraw/";
    description = "Free Software implementation for camera RAW files decoding";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ _360ied ];
  };
}
