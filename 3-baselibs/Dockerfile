ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS builder

ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --test=all --fail-fast"}

RUN spack solve -I                      --reuse "cmake~ncurses~ownlibs target=x86_64 ^curl tls=openssl" \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "cmake~ncurses~ownlibs target=x86_64 ^curl tls=openssl"

RUN spack solve -I                      --reuse "cmake@3.10.0~ncurses~ownlibs target=x86_64 ^curl tls=openssl" \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "cmake@3.10.0~ncurses~ownlibs target=x86_64 ^curl tls=openssl"

RUN mkdir -p ${SPACK_ROOT}/var/environments/baselibs
COPY baselibs.yaml ${SPACK_ROOT}/var/environments/baselibs/spack.yaml
RUN sed -i "s/@COMPILER@/${COMPILER}/" ${SPACK_ROOT}/var/environments/baselibs/spack.yaml

RUN spack env activate ${SPACK_ROOT}/var/environments/baselibs \
 && spack config add "packages:all:target:[x86_64]" \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && spack concretize --test=all --reuse \
 && spack install ${SPACK_INSTALL_ARGS}

RUN spack clean -a

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s || echo "Failed strip"


FROM ${BASE_IMAGE}

COPY --from=builder ${SPACK_HOME} ${SPACK_HOME}
COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}
