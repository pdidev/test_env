ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-3a-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG COMPILER
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

# --deprecated for some versions of our old env (python 3.6)
RUN spack -e pdienv concretize -fU
RUN spack -e pdienv install --deprecated ${SPACK_INSTALL_ARGS} $(cat compilerpkg.lst) \
 && spack mark -ia \
 && spack mark -e "/$(spack -e pdienv find --format '{name}' --no-groups -L $(cat compilerpkg.lst) | awk '{print $1}')" \
 && spack gc -y


# switch to our new, just built, compiler
RUN spack compiler remove --scope site -a gcc || true
RUN spack compiler remove --scope site -a clang || true
RUN spack -e pdienv compiler remove --scope env:pdienv -a gcc || true
RUN spack -e pdienv compiler remove --scope env:pdienv -a clang || true
RUN spack compiler remove -a clang || true
RUN spack compiler remove -a gcc || true
RUN spack compiler find --scope site \
          "$(spack -e pdienv find --format '{name}' --paths "$(cat compilerpkg.lst)%$(cat compiler.lst)" | awk '{print $2}')"
RUN spack compiler remove --scope defaults -a gcc || true
RUN spack compiler remove --scope defaults -a clang || true
RUN spack compiler remove --scope system -a gcc || true
RUN spack compiler remove --scope system -a clang || true
RUN spack compiler remove --scope user -a gcc || true
RUN spack compiler remove --scope user -a clang || true


# When the selected suite does not offer a Fortran compiler (clang), use gfortran
RUN sed -i "s#f77\s*:\s*null#f77: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml
RUN sed -i "s#fc\s*:\s*null#fc: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml
