ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-2c-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


COPY spack.yaml spack.yaml
RUN spack env create pdienv spack.yaml \
 && spack clean -a
RUN spack -e pdienv add -l compilerpkg $(cat compilerpkg.lst) \
 && spack clean -a
RUN spack -e pdienv add -l compiler $(cat compiler.lst) \
 && spack clean -a


COPY baselibs.lst baselibs.lst
RUN DEFAULT_IFS="${IFS}" \
  ; IFS=$'\n' \
  ; set -f \
  ; for LIB in $(cat baselibs.lst)\
  ; do IFS="${DEFAULT_IFS}" spack -e pdienv add -l baselibs "${LIB}" \
  ; done


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN spack -e pdienv concretize -fU \
 && spack clean -a
RUN spack -e pdienv fetch $(cat compilerpkg.lst) \
 || spack -e pdienv fetch $(cat compilerpkg.lst) \
 || spack -e pdienv fetch $(cat compilerpkg.lst) \
 || spack -e pdienv fetch $(cat compilerpkg.lst) \
 && spack clean -a
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS} --only dependencies $(cat compilerpkg.lst) \
 && spack clean -a
