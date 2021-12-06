ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG MPI
ARG SPACK_INSTALL_ARGS
ARG PARALLELISM=1

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --fail-fast"}
ENV MPI=${MPI}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN set -ex \
 && for N in {2..${PARALLELISM}} \
  ; do spack install ${SPACK_INSTALL_ARGS}  "${MPI}%${COMPILER}" "^${CMAKE}" \
  & done \
 && spack install ${SPACK_INSTALL_ARGS} "${MPI}%${COMPILER}" "^${CMAKE}"
