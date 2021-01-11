# Docker images:

A set of related Docker images to build and test PDI.

Their relationship is as follow:
```
xenial_cmake3.5 -> xenial_libs_cmake3.5 -> xenial_libs_cmake3.10
               \
                `-> xenial_cmake3.10
```

## xenial_cmake3.5

Ubuntu Xenial with the minimal set of dependencies installed to build the full
PDI distribution in "embedded" mode (without running the tests).

Used for PDI "embedded" build with cmake 3.5 (using all libs embedded in the PDI
distribution, except for SIONlib)

## xenial_cmake3.10

xenial_cmake3.5 extented with the minimal dependencies to build the full PDI 
distribution with cmake-3.10 and to run the tests:
* cmake 3.10

Used for PDI "embedded" build and tests with cmake 3.10 (using all libs embedded
in the PDI distribution)

## xenial_libs_cmake3.5

Building of the dependencies required for the PDI distribution without relying
on embedded dependencies:
* doxygen,
* flowvr,
* fti,
* netcdf.

Installation of the libs that are available as packages:
* astyle,
* hdf5,
* paraconf,
* spdlog,
* pybind11,
* zpp.

Used for PDI "system" build with cmake 3.5 (using all libs from the docker
image)

## xenial_libs_cmake3.10

xenial_libs_cmake3.5 extented with the minimal dependencies to build the full
PDI distribution with cmake-3.10 and to run the tests:
* cmake 3.10

Used for PDI "system" build and tests with cmake 3.10 (using all libs from the
docker image)
