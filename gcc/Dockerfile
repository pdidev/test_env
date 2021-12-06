ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG GCC_VERSION
ARG SPACK_INSTALL_ARGS
ARG PARALLELISM=1

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --fail-fast"}
ENV COMPILER=gcc${GCC_VERSION}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN set -ex \
 && for N in {2..${PARALLELISM}} \
  ; do spack install ${SPACK_INSTALL_ARGS}  "${COMPILER}" \
  & done \
 && spack install ${SPACK_INSTALL_ARGS} "${COMPILER}" \
 && spack load ${COMPILER} \
 && spack compiler find \
 && spack unload ${COMPILER} \
 && spack config add 'compilers:compiler:target:[x86_64]'
