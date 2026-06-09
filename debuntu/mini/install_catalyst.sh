#!/bin/bash
set -x
cmake_catalyst_required=3.26.0
cmake_installed=$(cmake --version | head -1 | cut -f3 -d" ")

mapfile -t sorted < <(printf "%s\n" "$cmake_installed" "$cmake_catalyst_required" | sort -V)

if [[ ${sorted[0]} == "$cmake_catalyst_required" ]]; then
    cmake --install ${HOME}/catalyst_clone/build
else
    /home/ci/local-cmake/install/bin/cmake --install ${HOME}/catalyst_clone/build
fi
