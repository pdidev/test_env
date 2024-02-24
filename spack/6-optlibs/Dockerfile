ARG VERSION
ARG COMPILER
ARG MPI
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-${MPI}-mini-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"



RUN git clone --depth 1 https://github.com/pdidev/spack ${SPACK_ROOT}/var/spack/repos/pdi \
 && rm -rf ${SPACK_ROOT}/var/spack/repos/pdi/.git \
 && spack repo add --scope site ${SPACK_ROOT}/var/spack/repos/pdi \
 && spack clean -a



COPY optlibs.lst optlibs.lst

RUN DEFAULT_IFS="${IFS}" \
  ; IFS=$'\n' \
  ; set -f \
  ; for LIB in $(cat optlibs.lst)\
  ; do IFS="${DEFAULT_IFS}" spack -e pdienv add -l optlibs "${LIB}" \
  ; done \
 && spack clean -a



ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

# install the libs
RUN spack -e pdienv concretize -fU \
 && spack clean -a
RUN ( if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi ) \
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} \
 && spack clean -a
