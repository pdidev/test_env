ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG COMPILER
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

COPY ${COMPILER}-${VERSION}.lst compiler.lst
RUN spack solve -I --reuse $(cat compiler.lst) target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse $(cat compiler.lst) target=x86_64

RUN spack find --no-groups  "$(cat compiler.lst)" > compilerpkg.lst \
 && cp compilerpkg.lst compiler.lst \
 && sed 's/llvm/clang/' -i compiler.lst

# switch to our new, just built, compiler
RUN spack compiler remove --scope site -a gcc || true
RUN spack compiler remove --scope site -a clang || true
RUN spack -e pdienv compiler remove --scope env:pdienv -a gcc || true
RUN spack -e pdienv compiler remove --scope env:pdienv -a clang || true
RUN spack compiler remove -a clang || true
RUN spack compiler remove -a gcc || true
RUN spack compiler find --scope site \
 "$(spack find --format '{name}' --paths "$(cat compilerpkg.lst)" | awk '{print $2}')"
RUN spack -e pdienv compiler remove --scope env:pdienv -a gcc || true
RUN spack -e pdienv compiler remove --scope env:pdienv -a clang || true
RUN spack compiler remove -a gcc || true
RUN spack compiler remove -a clang || true
 
# When the selected suite does not offer a Fortran compiler (clang), use gfortran
RUN sed -i "s#f77\s*:\s*null#f77: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml
RUN sed -i "s#fc\s*:\s*null#fc: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml

# TODO: This is likely only required for openmpi, but this is a workaround until solving
# https://github.com/spack/spack/issues/4610
RUN if grep -qs clang compiler.lst \
  ; then sed 's/flags\s*:.*/flags: { fflags: "-fPIC", cflags: "-fPIC", cxxflags: "-fPIC" }/' \
             -i ${SPACK_ROOT}/etc/spack/compilers.yaml \
  ; fi
