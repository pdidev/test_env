ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-2a-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN spack solve -I --reuse $(cat compilerpkg.lst) target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse $(cat compilerpkg.lst) target=x86_64 \
 && spack clean -a


# Workaround clang 14.0.2 that reports version as 14.0.1
RUN spack find --no-groups  "$(cat compilerpkg.lst)" > compilerpkg.lst \
 && cp compilerpkg.lst compiler.lst \
 && sed 's/llvm/clang/' -i compiler.lst \
 && sed 's/clang@14.0.2/clang@14.0.1/' -i compiler.lst \
 && spack clean -a


# switch to our new, just built, compiler
RUN spack compiler remove --scope site -a gcc || true \
 && spack clean -a
RUN spack compiler remove --scope site -a clang || true \
 && spack clean -a
RUN spack compiler remove -a clang || true \
 && spack clean -a
RUN spack compiler remove -a gcc || true \
 && spack clean -a
RUN spack compiler find --scope site \
          "$(spack find --format '{name}' --paths "$(cat compilerpkg.lst)" | awk '{print $2}')" \
 && spack clean -a
RUN spack compiler remove --scope defaults -a gcc || true \
 && spack clean -a
RUN spack compiler remove --scope defaults -a clang || true \
 && spack clean -a
RUN spack compiler remove --scope system -a gcc || true \
 && spack clean -a
RUN spack compiler remove --scope system -a clang || true \
 && spack clean -a
RUN spack compiler remove --scope user -a gcc || true \
 && spack clean -a
RUN spack compiler remove --scope user -a clang || true \
 && spack clean -a


# When the selected suite does not offer a Fortran compiler (clang), use gfortran
RUN sed -i "s#f77\s*:\s*null#f77: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml
RUN sed -i "s#fc\s*:\s*null#fc: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml
