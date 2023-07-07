ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-2c-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


RUN spack -e pdienv add -l compilerpkg $(cat compilerpkg.lst)
RUN spack -e pdienv add -l compiler $(cat compiler.lst)


ARG VERSION

COPY ${VERSION}.lst baselibs.lst
RUN DEFAULT_IFS="${IFS}" \
  ; IFS=$'\n' \
  ; set -f \
  ; for LIB in $(cat baselibs.lst)\
  ; do IFS="${DEFAULT_IFS}" spack -e pdienv add -l baselibs "${LIB}" \
  ; done


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

# --deprecated for some versions of our old env (python 3.6)
RUN spack -e pdienv concretize -fU
RUN spack -e pdienv fetch --deprecated $(cat compilerpkg.lst) \
 || spack -e pdienv fetch --deprecated $(cat compilerpkg.lst) \
 || spack -e pdienv fetch --deprecated $(cat compilerpkg.lst) \
 || spack -e pdienv fetch --deprecated $(cat compilerpkg.lst)
RUN spack -e pdienv install --deprecated ${SPACK_INSTALL_ARGS} --only dependencies $(cat compilerpkg.lst)
