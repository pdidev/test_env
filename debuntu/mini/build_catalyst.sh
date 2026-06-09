#!/bin/bash
set -x
cmake_catalyst_required=3.26.0
cmake_installed=$(cmake --version | head -1 | cut -f3 -d" ")

mapfile -t sorted < <(printf "%s\n" "$cmake_installed" "$cmake_catalyst_required" | sort -V)

cmake_executable=cmake 
if [[ ${sorted[0]} == "$cmake_catalyst_required" ]]; then
    cmake_executable=cmake
else
    cmake_executable=/home/ci/local-cmake/install/bin/cmake
fi
git clone --branch v2.0.0 \
        --single-branch \
        https://gitlab.kitware.com/paraview/catalyst.git \
        ${HOME}/catalyst_clone/
mkdir ${HOME}/catalyst_clone/
mkdir build
git submodule update --depth=1 --init --recursive
${cmake_executable} -GNinja -DCATALYST_BUILD_TESTING:BOOL=OFF \
    -DCATALYST_USE_MPI:BOOL=ON \
    -DCATALYST_WRAP_FORTRAN:BOOL=OFF \
    -DCATALYST_WRAP_PYTHON:BOOL=ON \
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/catalyst/ \
    -S ${HOME}/catalyst_clone/ -B ${HOME}/catalyst_clone/build
${cmake_executable} --build ${HOME}/catalyst_clone/build