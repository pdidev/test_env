ARG VERSION
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-1c-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG VERSION
ARG COMPILER
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

COPY ${COMPILER}-${VERSION}.lst compilerpkg.lst
RUN spack solve -I --reuse $(cat compilerpkg.lst) target=x86_64 \
 && spack install --deprecated ${SPACK_INSTALL_ARGS} --reuse --only dependencies $(cat compilerpkg.lst) target=x86_64
