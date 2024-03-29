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
RUN spack -e pdienv concretize --reuse --force
# install & workaround openmpi issue with mixed compilers where Fortran CHARACTER detection script requires CFLAGS=-fPIE
RUN  ( spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated ) \
 &&  ( if ( [ 'xopenmpi' = "x${MPI}" -a 'xoldest' = "x${VERSION}" ] && grep -qs clang compiler.lst ) \
     ; then  ( spack -e pdienv install --only dependencies ${SPACK_INSTALL_ARGS} openmpi \
            && export CFLAGS=-fPIE \
            && spack -e pdienv install ${SPACK_INSTALL_ARGS} --dirty openmpi ) \
     ; else true \
     ; fi ) \
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} \
 && spack clean -a
