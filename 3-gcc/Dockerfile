ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN [[ "oldest" = "${VERSION}" ]] || spack config remove packages:gcc

COPY ${VERSION}.lst compiler.lst
RUN spack -e pdienv add -l compiler $(cat compiler.lst)
RUN spack solve -I --reuse $(cat compiler.lst) \
 && spack install ${SPACK_INSTALL_ARGS} --reuse $(cat compiler.lst) \
 && spack gc -y

RUN spack load $(cat compiler.lst) \
 && spack compiler find
RUN [[ "oldest" = "${VERSION}" ]] || spack compiler remove gcc@7.5.0
