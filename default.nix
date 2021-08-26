# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  krita-4latest = with pkgs; pkgs.callPackage ./pkgs/krita/krita-4latest { 
    inherit lib stdenv makeWrapper cmake extra-cmake-modules
    breeze-icons boost libraw fftw eigen exiv2 libheif lcms2 gsl openexr giflib
    openjpeg opencolorio vc poppler curl ilmbase
    python3Packages; 
    inherit (libsForQt5) karchive kconfig kwidgetsaddons kcompletion kcoreaddons
    kguiaddons ki18n kitemmodels kitemviews kwindowsystem kio kcrash
    qtmultimedia qtx11extras quazip;
    inherit (qt5) mkDerivation;
  };
  
  krita-5beta = with pkgs; pkgs.callPackage ./pkgs/krita/krita-5beta { 
    inherit lib stdenv makeWrapper fetchurl cmake extra-cmake-modules
    breeze-icons boost libraw fftw eigen exiv2 libheif lcms2 gsl openexr giflib
    openjpeg opencolorio vc poppler curl ilmbase
    python3Packages; 
    inherit (libsForQt5) karchive kconfig kwidgetsaddons kcompletion kcoreaddons
    kguiaddons ki18n kitemmodels kitemviews kwindowsystem kio kcrash
    qtmultimedia qtx11extras quazip;
    inherit (qt5) mkDerivation;
  };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
