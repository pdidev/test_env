ARG VERSION
ARG COMPILER
ARG MPI
ARG IMAGE_TAG
ARG REGISTRY=ghcr.io/pdidev/test_env

FROM ${REGISTRY}/builder:${VERSION}-${COMPILER}-${MPI}-mini-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


# before 1.0, add the external repo for paraconf
RUN <<EORUN
set -e
if ! ( spack --version | grep -qs '^1\.' )
then
  git clone --depth 1 https://github.com/pdidev/spack ${SPACK_ROOT}/var/spack/repos/pdi
  rm -rf ${SPACK_ROOT}/var/spack/repos/pdi/.git
  spack repo add --scope site ${SPACK_ROOT}/var/spack/repos/pdi
fi
EORUN


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

# Add the optional libraries to our environment and install it
RUN . deps.sh && spack -e pdienv add -l libs    ${OPT_LIBS}
RUN . deps.sh && spack -e pdienv add -l mpilibs ${OPT_MPILIBS}
RUN spack -e pdienv concretize -f  --reuse
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS}
