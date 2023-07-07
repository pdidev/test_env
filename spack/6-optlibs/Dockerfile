ARG VERSION
ARG COMPILER
ARG MPI
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-${MPI}-mini-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN git clone --depth 1 https://github.com/leobago/fti-spack ${SPACK_ROOT}/var/spack/repos/fti
RUN rm -rf ${SPACK_ROOT}/var/spack/repos/fti/.git
RUN spack repo add --scope site ${SPACK_ROOT}/var/spack/repos/fti

RUN git clone --depth 1 https://github.com/pdidev/spack ${SPACK_ROOT}/var/spack/repos/pdi
RUN rm -rf ${SPACK_ROOT}/var/spack/repos/pdi/.git
RUN spack repo add --scope site ${SPACK_ROOT}/var/spack/repos/pdi


COPY ${VERSION}.lst optlibs.lst

RUN DEFAULT_IFS="${IFS}" \
  ; IFS=$'\n' \
  ; set -f \
  ; for LIB in $(cat optlibs.lst)\
  ; do IFS="${DEFAULT_IFS}" spack -e pdienv add -l optlibs "${LIB}" \
  ; done

# some package need to use a more recent cmake than that of in old env, so remove it
RUN spack -e pdienv remove -l baselibs cmake

# install the libs
RUN spack -e pdienv concretize --reuse
RUN  ( spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated ) \
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} \
 && spack clean -a

# add back the cmake version that was removed before
RUN spack -e pdienv add -l baselibs "$(grep '^cmake' baselibs.lst)"
RUN spack -e pdienv concretize --reuse
RUN  ( spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated \
    || spack -e pdienv fetch --deprecated ) \
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} \
 && spack clean -a
