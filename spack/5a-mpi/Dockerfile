ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-4b-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG VERSION
ARG MPI
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

COPY ${MPI}-${VERSION}.lst mpi.lst
RUN DEFAULT_IFS="${IFS}" \
  ; IFS=$'\n' \
  ; set -f \
  ; for LIB in $(cat mpi.lst)\
  ; do IFS="${DEFAULT_IFS}" spack -e pdienv add -l mpi "${LIB}" \
  ; done
RUN spack -e pdienv concretize --reuse
RUN  ( spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated ) \
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} \
 && spack clean -a
