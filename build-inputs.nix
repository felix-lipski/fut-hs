{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  customGhc = haskellPackages.ghcWithPackages (pkgs: with pkgs; [
  ]);
  customPython = pkgs.python39.buildEnv.override {
    extraLibs = with pkgs.python39Packages; [
      numpy
      pillow
      pyopencl
    ];
  };
in
[ customPython ] ++ 
[ customGhc ] ++ 
[
  futhark
  opencl-headers
  opencl-info
  clinfo
]
