ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG GCC_VERSION
ARG PARALLELISM=1
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --fail-fast"}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

COPY tests/compiler_install /
RUN spack install gcc${GCC_VERSION} \
 && spack load gcc${GCC_VERSION} \
 && spack compiler find \
 && spack unload gcc${GCC_VERSION}
