ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG CMAKE_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV CMAKE=cmake${CMAKE_VERSION}

RUN set -ex \
 && spack solve -I                      --reuse "cmake"    "~ncurses" "~ownlibs" target=x86_64 "%${COMPILER}" \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "cmake"    "~ncurses" "~ownlibs" target=x86_64 "%${COMPILER}" \
 && spack solve -I                      --reuse "${CMAKE}" "~ncurses" "~ownlibs" target=x86_64 "%${COMPILER}" \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${CMAKE}" "~ncurses" "~ownlibs" target=x86_64 "%${COMPILER}"

RUN mkdir /opt/baselibs-env
COPY baselibs.yaml /opt/baselibs-env/spack.yaml
RUN sed -i "s/@COMPILER@/${COMPILER}/" /opt/baselibs-env/spack.yaml \
 && spack env activate /opt/baselibs-env \
 && spack config add "packages:all:target:[x86_64]" \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && spack concretize --test=all --reuse \
 && spack install ${SPACK_INSTALL_ARGS} \
 && find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s || true
