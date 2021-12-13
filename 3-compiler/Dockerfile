ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG COMPILER
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

ENV COMPILER=${COMPILER}

RUN ( [ "gcc@7.5.0" = "${COMPILER}" ] || spack config remove packages:gcc )

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && COMPSPEC="${COMPSPEC} $([[ ${COMPILER} =~ "^gcc" ]] && echo -n "~bootstrap" || true)" \
 && spack solve -I                      --reuse ${COMPSPEC} target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse ${COMPSPEC} target=x86_64

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && COMPSPEC="${COMPSPEC} $([[ ${COMPILER} =~ "^gcc" ]] && echo -n "~bootstrap" || true)" \
 && spack load ${COMPSPEC} \
 && spack compiler find
RUN spack config add "packages:all:compiler:[${COMPILER}]"
RUN sed 's/target:.*/target: x86_64/' -i ${SPACK_HOME}/linux/compilers.yaml
RUN DEFAULT_F77="$(grep '\bf77\b' ~/.spack/linux/compilers.yaml | grep -v '\bnull\b' | head -n 1 | sed 's/.*:\s*//')" \
 && sed -i "s#f77\s*:\s*null#f77: ${DEFAULT_F77}#I" ~/.spack/linux/compilers.yaml
RUN DEFAULT_FC="$(grep '\bfc\b' ~/.spack/linux/compilers.yaml | grep -v '\bnull\b' | head -n 1 | sed 's/.*:\s*//')" \
 && sed -i "s#fc\s*:\s*null#fc: ${DEFAULT_FC}#I" ~/.spack/linux/compilers.yaml

RUN ( [ "gcc@7.5.0" = "${COMPILER}" ] || spack compiler remove gcc@7.5.0 )
