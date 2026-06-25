#!/bin/bash
set -x
cmake_catalyst_required=3.26.0
cmake_installed=$(cmake --version | head -1 | cut -f3 -d" ")

mapfile -t sorted < <(printf "%s\n" "$cmake_installed" "$cmake_catalyst_required" | sort -V)

if [[ ${sorted[0]} == "$cmake_catalyst_required" ]]; then
    echo "cmake version $cmake_installed >= $cmake_catalyst_required"
else
    echo "compile cmake"
    git clone https://gitlab.kitware.com/cmake/cmake.git local-cmake
    cd local-cmake && git checkout v3.30.0
    echo "mkdir install"
    mkdir install
    echo "mkdir build"
    mkdir build && cd build
    set -x && ../bootstrap --prefix=../install -- -DCMAKE_USE_OPENSSL=OFF 
    make -j 8
    make install
fi
