ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-2c-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


COPY spack.yaml spack.yaml
RUN sed "s/@TARGET@/$(cat target)/g" -i spack.yaml \
 && spack env create pdienv spack.yaml \
 && spack -e pdienv add -l compilerpkg "$(cat compilerpkg.lst)" \
 && spack -e pdienv add -l compiler "$(cat compiler.lst)" \
 && spack clean -a


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN spack -e pdienv concretize -fU \
 && spack clean -a
RUN ( if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi ) \
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} --only dependencies "$(cat compilerpkg.lst)" \
 && spack clean -a
