ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-4b-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG MPI

COPY ${MPI}.lst mpi.lst
RUN DEFAULT_IFS="${IFS}" \
  ; IFS=$'\n' \
  ; set -f \
  ; for LIB in $(cat mpi.lst)\
  ; do IFS="${DEFAULT_IFS}" spack -e pdienv add -l mpi "${LIB}" \
  ; done \
 && spack clean -a


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN spack -e pdienv concretize -fU \
 && spack clean -a
# workaround clang issue with mixed compilers where Fortran CHARACTER detection script requires CFLAGS=-fPIE
# Still present with spack 0.18
RUN ( if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi ) \
 && if ( spack --version | grep -qs '^0\.18' && grep -qs clang compiler.lst ) \
  ; then spack -e pdienv install --only dependencies ${SPACK_INSTALL_ARGS} $(cat mpi.lst|head -n 1) \
      && ( export CFLAGS=-fPIE; spack -e pdienv install ${SPACK_INSTALL_ARGS} --dirty $(cat mpi.lst|head -n 1) ) \
  ; fi \
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} \
 && spack clean -a
