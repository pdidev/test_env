ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG CMAKE_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV CMAKE=cmake${CMAKE_VERSION}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN set -ex \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${CMAKE}%${COMPILER}" target=x86_64
