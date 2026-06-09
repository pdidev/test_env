ARG VERSION
ARG COMPILER
ARG MPI
ARG IMAGE_TAG
ARG REGISTRY=ghcr.io/pdidev/test_env

FROM ${REGISTRY}/builder:${VERSION}-${COMPILER}-baselibs-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG MPI
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

# Add our MPI of choice and base MPI-dependant libs to the environment and install it
RUN <<'EORUN'
set -e
echo "DEBUG COMPILER=[${COMPILER}] MPI=[${MPI}] spackver=[$(spack --version)]"
if [ "${COMPILER}" = gcc ] && [ "${MPI}" = openmpi ] && spack --version | grep -qs '^1\.'; then
# Use main branch of openmpi because it contains fix to issue #13756 that is still unreleased. 
  spack -e pdienv add -l mpi "openmpi@main"
else
  spack -e pdienv add -l mpi "${MPI}"
fi
EORUN
RUN . deps.sh && spack -e pdienv add -l mpilibs ${BASE_MPILIBS}
RUN spack -e pdienv concretize -f --reuse
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS}
