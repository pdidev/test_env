# Docker images:

A set of related Docker images to build and test PDI.

We provide images based on:
* Spack recipes,
* Binary packages.

## Spack-based images

These images are based on a minimal Ubuntu with spack and all dependencies installed through spack.

The images are named as: `ghcr.io/pdidev/spack/${deps_version}/${compiler}/${mpi}/${level}`
With the following parameters:
* `deps_version`:
  - `oldest`: everything is installed with the 0.18 release of spack,
  - `latest`: everything is installed with the latest development version of spack,
* `compiler`:
  - `gcc`:   using GCC compiler,
  - `clang`: using clang for C/C++ and gfortran for Fortran,
* `mpi`:
  - `openmpi`: using openmpi implementation of MPI,
* `level`:
  - `mini`: dependencies "vendored" in PDI are not included in the image,
  - `all`: dependencies "vendored" in PDI are included in the image.


## Binary package based images

These images are based on Debian or Ubuntu, with all dependencies installed through packages.

The images are named as: `ghcr.io/pdidev/${distribution}/${version}/${mpi}/${level}`
With the following parameters:
* `distribution`/`version`:
  - `debian`: the image is based on Debian GNU Linux, versions can be `oldstable`, or `unstable`,
  - `ubuntu`: the image is based on Ubuntu, versions can be `jammy`, or `rolling`,
* `mpi`:
  - `mpich`: using mpich implementation of MPI,
  - `openmpi`: using openmpi implementation of MPI,
* `mpi`:
  - `mpich`: using mpich implementation of MPI,
  - `openmpi`: using openmpi implementation of MPI,
* `level`:
  - `mini`: dependencies "vendored" in PDI are not included in the image,
  - `all`: dependencies "vendored" in PDI are included in the image,
  - `pdi`: PDI is included in the image.
