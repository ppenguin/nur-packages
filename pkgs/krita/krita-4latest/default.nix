{ mkDerivation, fetchurl, lib, stdenv, makeWrapper, cmake, extra-cmake-modules
, karchive, kconfig, kwidgetsaddons, kcompletion, kcoreaddons
, kguiaddons, ki18n, kitemmodels, kitemviews, kwindowsystem
, kio, kcrash, breeze-icons
, boost, libraw, fftw, eigen, exiv2, libheif, lcms2, gsl, openexr, giflib
, openjpeg, opencolorio, vc, poppler, curl, ilmbase
, qtmultimedia, qtx11extras, quazip
, python3Packages
}:

mkDerivation rec {
  pname = "krita";
  version = "4.4.8";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256:1y0d8gnxfdg5nfwk8dgx8fc2bwskvnys049napb1a9fr25bqmimw";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules python3Packages.sip_4 makeWrapper ];

  buildInputs = [
    karchive kconfig kwidgetsaddons kcompletion kcoreaddons kguiaddons
    ki18n kitemmodels kitemviews kwindowsystem kio kcrash breeze-icons
    boost libraw fftw eigen exiv2 lcms2 gsl openexr libheif giflib
    openjpeg opencolorio poppler curl ilmbase
    qtmultimedia qtx11extras quazip
    python3Packages.pyqt5
  ] ++ lib.optional (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64) vc;

  NIX_CFLAGS_COMPILE = [ "-I${ilmbase.dev}/include/OpenEXR" ]
    ++ lib.optional stdenv.cc.isGNU "-Wno-deprecated-copy";

  cmakeFlags = [
    "-DPYQT5_SIP_DIR=${python3Packages.pyqt5}/${python3Packages.python.sitePackages}/PyQt5/bindings"
    "-DPYQT_SIP_DIR_OVERRIDE=${python3Packages.pyqt5}/${python3Packages.python.sitePackages}/PyQt5/bindings"
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
  ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  meta = with lib; {
    description = "A free and open source painting application";
    homepage = "https://krita.org/";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}