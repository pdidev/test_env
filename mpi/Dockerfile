ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG MPI
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV MPI=${MPI}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN set -ex \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${MPI}%${COMPILER}" "^${CMAKE}" target=x86_64
