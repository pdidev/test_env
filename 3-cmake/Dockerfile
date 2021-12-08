ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG CMAKE_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV CMAKE=cmake${CMAKE_VERSION}

RUN set -ex \
 && spack solve --reuse "cmake%${COMPILER}~ncurses~ownlibs" target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "cmake%${COMPILER}" target=x86_64 \
 && spack solve --reuse "${CMAKE}%${COMPILER}~ncurses~ownlibs" target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${CMAKE}%${COMPILER}" target=x86_64

RUN mkdir /opt/baselibs-env
COPY baselibs.yaml /opt/baselibs-env/spack.yaml
RUN sed -i "s/@COMPILER@/${COMPILER}/" /opt/baselibs-env/spack.yaml \
 && spack env activate /opt/baselibs-env \
 && spack config add "packages:all:target:[x86_64]" \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && spack concretize --test=all --reuse \
 && spack install ${SPACK_INSTALL_ARGS}
