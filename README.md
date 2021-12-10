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
* mpi:
  - `openmpi_2.1.1`  the oldest version of OpenMPI supported by PDI,
  - `openmpi_latest` the latest version of OpenMPI available in spack at the
    time of generation,
* libs:
  - The version without `_${optlibs}` is the version where the "vendored"
    libraries from PDI are used,
  - `optlibs_oldest` the oldest versions of "vendored" libraries supported by
    PDI,
  - `optlibs_latest` the latest versions of "vendored" libraries supported by
    PDI.
