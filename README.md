# Docker images:

A set of related Docker images to build and test PDI.

The parameters are as follow:
* base:
  - `bionic` the base distribution is Ubuntu 18.08
* compiler:
  - `gcc-7.5.0`  the oldest version of GCC supported by PDI,
  - `gcc-latest` the latest version of GCC available in spack at the time of generation,
* cmake:
  - `cmake-3.10.0` the oldest version of CMake supported by PDI,
  - `cmake-latest` the latest version of CMake available in spack at the time of generation,
* mpi:
  - `openmpi-2.1.1`  the oldest version of OpenMPI supported by PDI,
  - `openmpi-latest` the latest version of OpenMPI available in spack at the time of generation,
* optlibs:
  - `optlibs-oldest` the oldest versions of "vendored" libraries supported by PDI,

This results in the following images:
* `pdidevel/bionic_${compiler}_${cmake}_${mpi}`
* `pdidevel/bionic_${compiler}_${cmake}_${mpi}_${optlibs}`
