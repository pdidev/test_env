# Docker images:

A set of related Docker images to build and test PDI 
[`pdidevel/pditst`](https://hub.docker.com/repository/docker/pdidevel/pditst).

All images are based on Ubuntu 18.08, with dependencies installed through
spack.

The images are named as:
`ghcr.io/pdidev/test_env/${deps_version}/${compiler}/${mpi}/${vendored}`

The parameters are as follow:
* deps_version:
  - `oldest`: dependencies use the oldest versions supported by PDI,
  - `latest`: dependencies use the latest versions available in spack at the
    time of generation,
* compiler:
  - `gcc`:   using GCC compiler,
  - `clang`: using clang for C/C++ and gfortran for Fortran,
* mpi:
  - `openmpi`: using openmpi implementation of MPI,
* vendored:
  - `nolibs`: dependencies "vendored" in PDI are not included in the image,
  - `libs`: dependencies "vendored" in PDI are included in the image.
