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
 && spack -e pdienv install ${SPACK_INSTALL_ARGS} "$(cat compilerpkg.lst)" \
 && spack mark -ia \
 && spack mark -e "/$(spack -e pdienv find --format '{name}' --no-groups -L "$(cat compilerpkg.lst)" | awk '{print $1}')" \
 && spack gc -y \
 && spack clean -a


# switch to our new, just built, compiler
RUN spack compiler remove --scope site -a gcc || true \
 && spack compiler remove --scope site -a clang || true \
 && spack compiler find --scope site \
          "$(spack find --format '{name}' --paths "$(cat compilerpkg.lst)" | awk '{print $2}')" \
 && spack clean -a


# use system gfortran for clang that doesn't support fortran
RUN set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
  ; if grep -q clang compiler.lst \
  ; then \
         apt-get update -y \
      && apt-get upgrade -y \
      && apt-get install -y --no-install-recommends \
                 gfortran-10 \
      && apt-get autoremove -y \
      && apt-get clean -y \
      && apt-get autoclean -y \
      && rm -rf /var/lib/apt/lists/*  \
      && sed "s%^\( *f\(77\|c\)\): *null%\1: /usr/bin/gfortran-10%" \
             -i /opt/spack/etc/spack/compilers.yaml \
  ; fi
