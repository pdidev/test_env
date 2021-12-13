ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG MPI
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

ENV MPI=${MPI}

RUN spack solve -I                      --reuse "${MPI} ^cmake~ownlibs^curl" tls=openssl target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${MPI} ^cmake~ownlibs^curl" tls=openssl target=x86_64
