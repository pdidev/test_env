ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-nolibs-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG COMPILER
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

COPY cmake-${VERSION}.lst cmake.lst
RUN spack solve -I --reuse $(cat cmake.lst) \
 && spack install ${SPACK_INSTALL_ARGS} --reuse $(cat cmake.lst) target=x86_64

COPY ${VERSION}.lst baselibs.lst
RUN spack -e pdienv add -l baselibs $(cat baselibs.lst)
RUN spack -e pdienv concretize --reuse \
 || spack -e pdienv concretize --reuse -f
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS}
