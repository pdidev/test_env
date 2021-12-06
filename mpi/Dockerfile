ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG MPI
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --fail-fast"}
ENV MPI=${MPI}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN spack install ${MPI}
