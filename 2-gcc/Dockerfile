ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG GCC_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV COMPILER=gcc${GCC_VERSION}

RUN set -ex \
 && ( [ "@7.5.0" = "${GCC_VERSION}" ] || spack config remove packages:gcc ) \
 && spack solve --reuse "${COMPILER}" target=x86_64 ~bootstrap \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${COMPILER}" target=x86_64 ~bootstrap \
 && spack load ${COMPILER} \
 && spack compiler find \
 && spack unload ${COMPILER} \
 && sed 's/target:.*/target: x86_64/' -i /root/.spack/linux/compilers.yaml
