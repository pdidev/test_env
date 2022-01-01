ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

COPY ${VERSION}.lst compiler.lst
RUN spack solve -I --reuse $(cat compiler.lst) \
 && spack install ${SPACK_INSTALL_ARGS} --reuse $(cat compiler.lst) \
 && spack gc -y

RUN spack load $(cat compiler.lst) \
 && spack compiler find
RUN spack compiler remove -a gcc

RUN sed 's/llvm/clang/' -i compiler.lst
RUN spack -e pdienv add -l compiler $(cat compiler.lst)

RUN sed -i "s#f77\s*:\s*null#f77: /usr/bin/gfortran#I" ${SPACK_HOME}/linux/compilers.yaml
RUN sed -i "s#fc\s*:\s*null#fc: /usr/bin/gfortran#I" ${SPACK_HOME}/linux/compilers.yaml

# TODO: This is likely only required for openmpi, but this is a workaround until solving
# https://github.com/spack/spack/issues/4610
RUN sed 's/flags\s*:.*/flags: { fflags: "-fPIC", cflags: "-fPIC", cxxflags: "-fPIC" }/' \
        -i ${SPACK_HOME}/linux/compilers.yaml
