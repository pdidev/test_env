ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG GCC_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --fail-fast"}
ENV COMPILER=gcc${GCC_VERSION}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN set -ex \
 && spack install ${COMPILER} \
 && spack load ${COMPILER} \
 && spack compiler find \
 && spack unload ${COMPILER}
