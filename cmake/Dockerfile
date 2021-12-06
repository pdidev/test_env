ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG CMAKE_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --fail-fast"}
ENV CMAKE=cmake${CMAKE_VERSION}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN spack install "${CMAKE}%${COMPILER}"
