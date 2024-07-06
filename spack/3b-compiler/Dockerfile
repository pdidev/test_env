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


# add the dependencies required for the old flang to work, TODO: move to base
RUN if grep -q clang@14.0.1 compiler.lst \
  ; then export DEBIAN_FRONTEND=noninteractive \
      && apt-get update -y \
      && apt-get upgrade -y \
      && apt-get install -y --no-install-recommends \
                 gfortran \
                 uuid-runtime \
      && apt-get autoremove -y \
      && apt-get clean -y \
      && apt-get autoclean -y \
  ; fi


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


# force old flang that's otherwise not detected
RUN if grep -q clang@14.0.1 compiler.lst \
  ; then sed "s%^\( *f\(77\|c\)\): *null%\1: $(spack find --format '{name}' --paths "$(cat compilerpkg.lst)" | awk '{print $2}')/bin/flang-new%" \
             -i /opt/spack/etc/spack/compilers.yaml \
  ; fi


# flang 18.1.fails with -mtune=generic
RUN if grep -q clang compiler.lst && ! grep -q clang@14.0.1 compiler.lst \
  ; then sed -e "s%-mtune=generic%%" -i /opt/spack/lib/spack/external/archspec/json/cpu/microarchitectures.json \
  ; fi
