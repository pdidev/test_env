ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG COMPILER
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV COMPILER=${COMPILER}

RUN set -ex \
 && ( [ "gcc@7.5.0" = "${COMPILER}" ] || spack config remove packages:gcc ) \
 && COMPSPEC=${COMPILER/clang/llvm} \
 && COMPSPEC="${COMPSPEC} $([[ ${COMPILER} =~ "^gcc" ]] && echo -n "~bootstrap" || true)" \
 && spack solve -I                      --reuse ${COMPSPEC} target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse ${COMPSPEC} target=x86_64 \
 && spack load ${COMPSPEC} \
 && spack compiler find \
 && spack unload ${COMPSPEC} \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && sed 's/target:.*/target: x86_64/' -i /root/.spack/linux/compilers.yaml \
 && DEFAULT_F77="$(grep '\bf77\b' ~/.spack/linux/compilers.yaml | grep -v '\bnull\b' | head -n 1 | sed 's/.*:\s*//')" \
 && sed -i "s#f77\s*:\s*null#f77: ${DEFAULT_F77}#I" ~/.spack/linux/compilers.yaml \
 && DEFAULT_FC="$(grep '\bfc\b' ~/.spack/linux/compilers.yaml | grep -v '\bnull\b' | head -n 1 | sed 's/.*:\s*//')" \
 && sed -i "s#fc\s*:\s*null#fc: ${DEFAULT_FC}#I" ~/.spack/linux/compilers.yaml \
 && find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s || true
