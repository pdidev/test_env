ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG COMPILER
ARG MPI
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

COPY ${MPI}-${VERSION}.lst mpi.lst
RUN spack -e pdienv add -l mpi $(cat mpi.lst)
RUN spack -e pdienv concretize --reuse \
 || spack -e pdienv concretize --reuse -f
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS}
