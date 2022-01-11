#!/usr/bin/env bash

set -ex

export CC="$PREFIX/bin/mpicc" FC="$PREFIX/bin/mpifort" CXX="$PREFIX/bin/mpicxx"

INC_PATHS=(
  $(pkg-config elpa_openmp --cflags-only-I | sed s+-I++g)
  $(pkg-config libOMM MatrixSwitch --cflags-only-I | sed s+-I++g)
)
LIB_PATHS=(
  $(pkg-config elpa_openmp --libs-only-L | sed s+-L++g)
  $(pkg-config libOMM MatrixSwitch --libs-only-L | sed s+-L++g)
)
LIBS=(
  $(pkg-config elpa_openmp --libs-only-l)
  "-lNTPoly"
  $(pkg-config libOMM MatrixSwitch --libs-only-l)
  "-lpexsi"
  "-lscalapack"
  "-llapack"
  "-lblas"
)

cmake_options=(
  ${CMAKE_ARGS}
  "-DCMAKE_Fortran_COMPILER=$FC"
  "-DCMAKE_C_COMPILER=$CC"
  "-DCMAKE_CXX_COMPILER=$CXX"
  "-DUSE_EXTERNAL_ELPA=ON"
  "-DUSE_EXTERNAL_NTPOLY=ON"
  "-DUSE_EXTERNAL_OMM=ON"
  "-DENABLE_PEXSI=ON"
  "-DUSE_EXTERNAL_PEXSI=ON"
  "-DBUILD_SHARED_LIBS=ON"
  "-DLIBS=${LIBS[*]// /;}"
  "-DLIB_PATHS=${LIB_PATHS[*]// /;}"
  "-DINC_PATHS=${INC_PATHS[*]// /;}"
)

cmake "${cmake_options[@]}" -GNinja -B_build
cmake --build _build
cmake --install _build
