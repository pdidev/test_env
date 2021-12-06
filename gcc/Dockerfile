ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG GCC_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV COMPILER=gcc${GCC_VERSION}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN set -ex \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${COMPILER}" target=x86_64 \
 && spack load ${COMPILER} \
 && spack compiler find \
 && spack unload ${COMPILER} \
 && sed 's/target:.*/target: x86_64/' -i /root/.spack/linux/compilers.yaml
