ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-nolibs-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG COMPILER
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN spack -e pdienv add -l compilerpkg $(cat compilerpkg.lst)
RUN spack -e pdienv add -l compiler $(cat compiler.lst)

COPY ${VERSION}.lst baselibs.lst
RUN DEFAULT_IFS="${IFS}" \
  ; IFS=$'\n' \
  ; set -f \
  ; for LIB in $(cat baselibs.lst)\
  ; do IFS="${DEFAULT_IFS}" spack -e pdienv add -l baselibs "${LIB}" \
  ; done

RUN spack -e pdienv concretize -fU
 
# --deprecated for some versions of our old env (python 3.6)
RUN spack -e pdienv install --deprecated ${SPACK_INSTALL_ARGS}

# switch to our new, just built, compiler
RUN spack compiler remove --scope site -a gcc || true
RUN spack compiler remove --scope site -a clang || true
RUN spack -e pdienv compiler remove --scope env:pdienv -a gcc || true
RUN spack -e pdienv compiler remove --scope env:pdienv -a clang || true
RUN spack compiler remove -a clang || true
RUN spack compiler remove -a gcc || true
RUN spack compiler find --scope site \
 "$(spack -e pdienv find --format '{name}' --paths "$(cat compilerpkg.lst)%$(cat compiler.lst)" | awk '{print $2}')"
RUN spack -e pdienv compiler remove --scope env:pdienv -a gcc || true
RUN spack -e pdienv compiler remove --scope env:pdienv -a clang || true
RUN spack compiler remove -a gcc || true
RUN spack compiler remove -a clang || true

# When the selected suite does not offer a Fortran compiler (clang), use gfortran
RUN sed -i "s#f77\s*:\s*null#f77: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml
RUN sed -i "s#fc\s*:\s*null#fc: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml

# TODO: This is likely only required for openmpi, but this is a workaround until solving
# https://github.com/spack/spack/issues/4610
RUN grep -qs gcc compiler.lst \
 || sed 's/flags\s*:.*/flags: { fflags: "-fPIC", cflags: "-fPIC", cxxflags: "-fPIC" }/' \
        -i ${SPACK_ROOT}/etc/spack/compilers.yaml
