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
RUN <<EORUN
#TODO: introduced to handle a missing variant in spack<0.22, remove when our minimum requirement goes at or above that
set -e
. deps.sh
if ( spack --version | grep -qs '^1\.' )
then
  spack -e pdienv add -l mpilibs ${BASE_MPILIBS}
else
  spack -e pdienv add -l mpilibs ${BASE_MPILIBS_OLDSPACK}
fi
EORUN
RUN spack -e pdienv concretize -f --reuse
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS}
