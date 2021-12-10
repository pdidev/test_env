ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG COMPILER
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV COMPILER=${COMPILER}

RUN set -ex \
 && ( [ "gcc@7.5.0" = "${COMPILER}" ] || spack config remove packages:gcc ) \
 && COMPSPEC="${COMPILER/clang/llvm}" \
 && COMPSPEC="${COMPSPEC} $([[ ${COMPILER} =~ "^gcc" ]] && echo -n "~bootstrap" || true)" \
 && spack solve                         --reuse ${COMPSPEC} target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse ${COMPSPEC} target=x86_64 \
 && spack load ${COMPSPEC} \
 && spack compiler find \
 && spack unload ${COMPSPEC} \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && sed 's/target:.*/target: x86_64/' -i /root/.spack/linux/compilers.yaml
