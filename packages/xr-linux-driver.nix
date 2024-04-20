{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  patchelf,
  python311Packages,
  libusb,
  curl,
  libevdev,
  json_c,
  hidapi,
  openssl,
}:
stdenv.mkDerivation {
  pname = "xr-linux-driver";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "wheaney";
    repo = "XRLinuxDriver";
    rev = "b1b12736f3a063be0ccd6b32ce95264ec98b3070";
    sha256 = "sha256-lFXs/2ovjTI7jT1XPqUNV+U0ZQASetUFnEyLAxiS/Xk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [cmake pkg-config libusb curl libevdev json_c hidapi makeWrapper patchelf];
  buildInputs = with python311Packages; [python pyyaml];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  installPhase = ''
    patchelf --set-rpath ${lib.makeLibraryPath [libusb curl libevdev json_c hidapi openssl]} xrealAirLinuxDriver
    mkdir -p $out/bin
    cp ../bin/xreal_driver_config $out/bin
    cp ./xrealAirLinuxDriver $out/bin
  '';

  meta = {
    description = "Linux Driver for XR devices";
    homepage = "https://github.com/wheaney/XRLinuxDriver";
    license = lib.licenses.mit;
  };
}
