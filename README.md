# Docker images:

A set of related Docker images to build and test PDI.

Their relationship is as follow for centos:
```
centos_base ---------------> centos_cmake3.5 ----------------> centos_libs_cmake3.5
           \                                                /
            `-> centos_cmake3.10 -> centos_libs_cmake3.10 -'
```
and for Ubuntu Xenial
```
xenial_cmake3.5 -> xenial_libs_cmake3.5 -> xenial_libs_cmake3.10
               \
                `-> xenial_cmake3.10
```

## centos_base

Centos 7 with the minimal set of dependencies installed to build the full PDI
distribution in "embedded" mode, except for cmake.
It enables the SCL, EPEL and home:pdi repositories and activates devtoolset-7
by default.

## centos_cmake3.5

centos_base extended with the minimal dependencies to build the full PDI 
distribution with cmake-3.5 (without running the tests):
* cmake 3.5
* hdf5 because HDF5 build requires cmake-3.10

Used for PDI "embedded" build with cmake 3.5 (using all libs embedded in the PDI
distribution except for HDF5 from the docker image)

## centos_cmake3.10

centos_base extented with the minimal dependencies to build the full PDI 
distribution with cmake-3.10 and to run the tests:
* cmake 3.10
* numpy
* mpi4py

Used for PDI "embedded" build and tests with cmake 3.10 (using all libs embedded
in the PDI distribution)

## centos_libs_cmake3.10

Building of the dependencies required for the PDI distribution without relying
on embedded dependencies:
* astyle,
* bpp,
* doxygen,
* flowvr,
* fti,
* pybind11,
* sionlib.

Installation of the libs that are available as packages:
* hdf5,
* libparaconf,
* libyaml,
* spdlog.

Used for PDI "system" build and tests with cmake 3.10 (using all libs from the
docker image)

## centos_libs_cmake3.5

Integration of the libraries built inside centos_libs_cmake3.10 into 
centos_cmake3.5:
* astyle,
* bpp,
* flowvr,
* fti,
* pybind11,
* sionlib.

Installation of the libs that are available as packages:
* libparaconf,
* libyaml,
* spdlog.


Used for PDI "system" build with cmake 3.5 (using all libs from the docker image)

## xenial_cmake3.5

Ubuntu Xenial with the minimal set of dependencies installed to build the full
PDI distribution in "embedded" mode (without running the tests).

Used for PDI "embedded" build with cmake 3.5 (using all libs embedded in the PDI
distribution except for HDF5 from the docker image)

## xenial_cmake3.10

xenial_cmake3.5 extented with the minimal dependencies to build the full PDI 
distribution with cmake-3.10 and to run the tests:
* cmake 3.10

Used for PDI "embedded" build and tests with cmake 3.10 (using all libs embedded
in the PDI distribution)

## xenial_libs_cmake3.5

Building of the dependencies required for the PDI distribution without relying
on embedded dependencies:
* flowvr,
* fti,
* sionlib.

Installation of the libs that are available as packages:
* astyle,
* doxygen,
* libhdf5-mpich-dev,
* libparaconf-dev,
* libspdlog-dev,
* pybind11-dev,
* python,
* zpp.

Used for PDI "system" build with cmake 3.5 (using all libs from the docker image)

## xenial_libs_cmake3.10

xenial_libs_cmake3.5 extented with the minimal dependencies to build the full
PDI distribution with cmake-3.10 and to run the tests:
* cmake 3.10

Used for PDI "system" build and tests with cmake 3.10 (using all libs from the
docker image)
