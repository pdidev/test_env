ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-3c-${IMAGE_TAG} as builder

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN spack -e pdienv concretize -fU \
 && spack clean -a
RUN spack -e pdienv fetch \
 || spack -e pdienv fetch \
 || spack -e pdienv fetch \
 || spack -e pdienv fetch \
 && spack clean -a
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS} \
 && spack clean -a
