ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-3a-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

RUN spack -e pdienv concretize -fU \
 && spack clean -a
RUN ( if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi \
   || if ! spack -e pdienv fetch -m; then spack clean -a; false; fi ) \
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} $(cat compilerpkg.lst) \
 && spack mark -ia \
 && spack mark -e "/$(spack -e pdienv find --format '{name}' --no-groups -L $(cat compilerpkg.lst) | awk '{print $1}')" \
 && spack gc -y \
 && spack clean -a


# switch to our new, just built, compiler
RUN spack compiler remove --scope site -a gcc || true \
 && spack compiler remove --scope site -a clang || true \
 && spack compiler remove -a clang || true \
 && spack compiler remove -a gcc || true \
 && spack compiler find --scope site \
          "$(spack find --format '{name}' --paths "$(cat compilerpkg.lst)" | awk '{print $2}')" \
 && spack compiler remove --scope defaults -a gcc || true \
 && spack compiler remove --scope defaults -a clang || true \
 && spack compiler remove --scope system -a gcc || true \
 && spack compiler remove --scope system -a clang || true \
 && spack compiler remove --scope user -a gcc || true \
 && spack compiler remove --scope user -a clang || true \
 && spack clean -a


# When the selected suite does not offer a Fortran compiler (clang), use gfortran
RUN sed -i "s#f77\s*:\s*null#f77: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml
RUN sed -i "s#fc\s*:\s*null#fc: /usr/bin/gfortran#I" ${SPACK_ROOT}/etc/spack/compilers.yaml
