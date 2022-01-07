# Docker images:

A set of related Docker images to build and test PDI.

We provide images based on:
* Dask recipes,
* Binary packages.

## Dask-based images

These images are based on a minimal Ubuntu 18.08, with spack and all dependencies installed through
spack.

The images are named as: `ghcr.io/pdidev/spack/${deps_version}/${compiler}/${mpi}/${included}`
With the following parameters:
* `deps_version`:
  - `oldest`: dependencies use the oldest versions supported by PDI,
  - `latest`: dependencies use the latest versions available in spack at the time of generation,
* `compiler`:
  - `gcc`:   using GCC compiler,
  - `clang`: using clang for C/C++ and gfortran for Fortran,
* `mpi`:
  - `openmpi`: using openmpi implementation of MPI,
* `included`:
  - `mini`: dependencies "vendored" in PDI are not included in the image,
  - `all`: dependencies "vendored" in PDI are included in the image.


## Binary package based images

These images are based on Ubuntu 18.08, with all dependencies installed through packages.

The images are named as: `ghcr.io/pdidev/ubuntu/bionic/${mpi}/${included}`
With the following parameters:
* `mpi`:
  - `mpich`: using mpich implementation of MPI,
  - `openmpi`: using openmpi implementation of MPI,
* `included`:
  - `mini`: dependencies "vendored" in PDI are not included in the image,
  - `all`: dependencies "vendored" in PDI are included in the image,
  - `pdi`: PDI is included in the image.
