# Docker images:

A set of related Docker images to build and test PDI 
[`pdidevel/pditst`](https://hub.docker.com/repository/docker/pdidevel/pditst).

The images come in two categories of tags:
* `pdidevel/pditst:${compiler}-${mpi}`
* `pdidevel/pditst:${compiler}-${mpi}-${libs}`

All images are based on Ubuntu 18.08, with dependencies installed through
spack.
One should run `spack load` to make them available at compile-time.
Both the latest version of CMake available in spack at the time of
generation and `cmake-3.10.0` are available in the image.

The parameters are as follow:
* compiler:
  - `gcc_7.5.0`  the oldest version of GCC supported by PDI,
  - `gcc_latest` the latest version of GCC available in spack at the time of
    generation,
  - `clang_8.0.0`  the oldest version of clang supported by PDI,
  - `clang_latest` the latest version of clang available in spack at the time
    of generation,
* mpi:
  - `openmpi_2.1.1`  the oldest version of OpenMPI supported by PDI,
  - `openmpi_latest` the latest version of OpenMPI available in spack at the
    time of generation,
* libs:
  - without `-${libs}`: libraries "vendored" in PDI are not included,
  - `libs_oldest` the oldest versions of the libraries "vendored" in PDI are
    included,
  - `libs_latest` the latest versions of the libraries "vendored" in PDI are
    included,
