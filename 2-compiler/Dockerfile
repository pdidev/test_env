ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS builder

ARG COMPILER
ARG SPACK_INSTALL_ARGS

# No --test=all because many tests fail
ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --fail-fast"}
ENV COMPILER=${COMPILER}

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && COMPSPEC="${COMPSPEC} $([[ ${COMPILER} =~ "^gcc" ]] && echo -n "~bootstrap" || true)" \
 && echo COMPSPEC="${COMPSPEC}" >> env.sh

RUN ( [ "gcc@7.5.0" = "${COMPILER}" ] || spack config remove packages:gcc )

RUN . env.sh \
 && spack solve -I                      --reuse ${COMPSPEC} target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse ${COMPSPEC} target=x86_64

RUN . env.sh \
 && spack load ${COMPSPEC} \
 && spack compiler find
RUN spack config add "packages:all:compiler:[${COMPILER}]"
RUN sed 's/target:.*/target: x86_64/' -i ${SPACK_HOME}/linux/compilers.yaml
RUN DEFAULT_F77="$(grep '\bf77\b' ~/.spack/linux/compilers.yaml | grep -v '\bnull\b' | head -n 1 | sed 's/.*:\s*//')" \
 && sed -i "s#f77\s*:\s*null#f77: ${DEFAULT_F77}#I" ~/.spack/linux/compilers.yaml
RUN DEFAULT_FC="$(grep '\bfc\b' ~/.spack/linux/compilers.yaml | grep -v '\bnull\b' | head -n 1 | sed 's/.*:\s*//')" \
 && sed -i "s#fc\s*:\s*null#fc: ${DEFAULT_FC}#I" ~/.spack/linux/compilers.yaml

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s || echo "Failed strip"

RUN spack clean -a
