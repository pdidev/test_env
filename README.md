# Docker images:

A set of related Docker images to build and test PDI.

We provide images based on:
* Spack recipes,
* Binary packages.


## Spack-based images

These images are based on a minimal Ubuntu with spack and all dependencies installed through spack.

The images are named as: `ghcr.io/pdidev/spack/${version}/${compiler}/${mpi}/${variant}:v4`
With the following parameters:
* `version`:
  - `oldest`: everything is installed with the 0.19 release of spack,
  - `latest`: everything is installed with the latest development version of spack,
* `compiler`:
  - `gcc`:   using GCC compiler,
  - `clang`: using clang for C/C++ and gfortran for Fortran,
* `mpi`:
  - `mpich`: using mpich implementation of MPI,
  - `openmpi`: using openmpi implementation of MPI,
* `variant`:
  - `mini`: dependencies "vendored" in PDI are not included in the image,
  - `all`: dependencies "vendored" in PDI are included in the image.


## Binary package based images

These images are based on Debian or Ubuntu, with all dependencies installed through packages.

The images are named as: `ghcr.io/pdidev/${distribution}/${version}/${mpi}/${variant}:v4`
With the following parameters:
* `distribution`/`version`:
  - `debian/bookworm`: the image is based on Debian GNU Linux 12 `bookworm`
  - `debian/unstable`: the image is based on the Debian GNU Linux `unstable`
  - `ubuntu/jammy`: the image is based on Ubuntu `jammy jellyfish`
  - `ubuntu/rolling`: the image is based on Ubuntu latest release
* `mpi`:
  - `mpich`: using mpich implementation of MPI,
  - `openmpi`: using openmpi implementation of MPI,
* `variant`:
  - `mini`: dependencies "vendored" in PDI are not included in the image,
  - `all`: dependencies "vendored" in PDI are included in the image,
  - `pdi`: PDI is included in the image. The VeloC plugin is not present in this image for the time being. 


## Full Spack images

These images are like the spack images but contain a fully working spack in additions of the 
dependencies installed through spack.

The images are named as: `ghcr.io/pdidev/fullspack/${version}/${compiler}/${mpi}/${variant}:v4`
With the following parameters:
* `version`:
  - `oldest`: everything is installed with the 0.19 release of spack,
  - `latest`: everything is installed with the latest development version of spack,
* `compiler`:
  - `gcc`:   using GCC compiler,
  - `clang`: using clang for C/C++ and gfortran for Fortran,
* `mpi`:
  - `mpich`: using mpich implementation of MPI,
  - `openmpi`: using openmpi implementation of MPI,
* `variant`:
  - `mini`: dependencies "vendored" in PDI are not included in the image,
  - `all`: dependencies "vendored" in PDI are included in the image.


## Clang-format images

The images are named as: `ghcr.io/pdidev/run-clang-format:v4` and embed the
`run-clang-format` tool from `https://github.com/Sarcasm/run-clang-format/`
