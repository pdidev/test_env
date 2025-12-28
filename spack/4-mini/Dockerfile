ARG VERSION
ARG COMPILER
ARG MPI
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-baselibs-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG MPI
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

# Add our MPI of choice and base MPI-dependant libs to the environment and install it
RUN              spack -e pdienv add -l mpi    "${MPI}"
RUN . deps.sh && spack -e pdienv add -l mpilibs ${BASE_MPILIBS}
RUN spack -e pdienv concretize -f --reuse
# Workaround a clang issue with mixed compilers in 0.18 where Fortran CHARACTER detection script
# requires CFLAGS=-fPIE
RUN spack -e pdienv install --only dependencies ${SPACK_INSTALL_ARGS} "${MPI}"
RUN <<EORUN
set -ex
if spack --version | grep -qs '^0\.18' && spack find llvm &>/dev/null
then
  export CFLAGS=-fPIE
  spack -e pdienv install --dirty ${SPACK_INSTALL_ARGS} "${MPI}"
fi
EORUN
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS}
