# build tools that are required in all cases
BASE_BUILDDEPS="cmake doxygen pkgconf py-setuptools"
# libraries that are required in all cases
BASE_LIBS="py-numpy py-pyyaml python"
# libraries that depend on MPI & are required in all cases
BASE_MPILIBS="py-mpi4py"
# libraries that are optional because embedded in PDI
OPT_LIBS="paraconf py-pybind11 spdlog"
# libraries that depend on MPI & are optional because embedded in PDI
OPT_MPILIBS="hdf5 netcdf-c"
