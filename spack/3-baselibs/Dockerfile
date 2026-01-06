ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/spackbase:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG VERSION

# Download spack
COPY ${VERSION}.branch spack.branch
RUN mkdir -p ${SPACK_ROOT} \
 && git clone --depth 1 -b $(cat spack.branch) ${SPACK_ROOT} \
 && rm -rf ${SPACK_ROOT}/.git


# Make a spack-enabled shell our entrypoint
SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]


# Configure spack
RUN spack config --scope site add "packages:all:target:[x86_64_v2]" \
 && spack config --scope site add "config:install_tree:root:${SPACK_INSTALL}" \
 && spack config --scope site add "modules:default:roots:tcl:${SPACK_MODULES}"


# Detect our system compiler
RUN spack compiler find --scope site /usr


ARG COMPILER
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

# Install the spack compiler with our latest system compiler
COPY ${COMPILER}.lst compilerpkg.lst
RUN spack solve -I -U \
          "$(cat compilerpkg.lst)%$(spack compilers | tr ' ' '\n' | grep @)" \
 && spack install ${SPACK_INSTALL_ARGS} -U \
          "$(cat compilerpkg.lst)%$(spack compilers | tr ' ' '\n' | grep @)"


# Prevent building any new compiler
RUN spack config --scope site add 'packages:llvm:buildable: false'
RUN spack config --scope site add 'packages:gcc:buildable: false'


# Generate a compiler ref
# * before 1.0, rely on the compilers section and generate a mixed compiler for llvm
# * from spack 1.0 on, define a toolchain
RUN <<EORUN
set -e
if ( spack --version | grep -qs '^1\.' )
then
  # get the name of the just built spack compiler
  COMPILER="$(spack find -x --format '{name}@{version}' "$(cat compilerpkg.lst)")"
  # if using LLVM, add the system compiler as fortran compiler
  if spack find llvm &>/dev/null
  then FCMP="$(spack find -e --format '{name}@{version}' gcc)"
  else FCMP="${COMPILER}"
  fi
  # generate a toolchain with those
  cat<<-EOF > "$(spack config --scope site edit --print-file toolchains)"
    toolchains:
      pditoolchain:
      - spec: "%c=${COMPILER}"
        when: "%c"
      - spec: "%cxx=${COMPILER}"
        when: "%cxx"
      - spec: "%fortran=${FCMP}"
        when: "%fortran"
EOF
else
  # remove the system compiler and instead detect the newly built compiler
  spack compiler remove --scope site -a gcc
  spack compiler find --scope site \
        "$(spack find -x --format '{name}' --paths "$(cat compilerpkg.lst)" | awk '{print $2}')"
  # if using LLVM, add system gfortran as fortran compiler
  if spack find llvm &>/dev/null
  then sed "s%^\( *f\(77\|c\)\): *null%\1: /usr/bin/gfortran%" \
           -i "$(spack config --scope site edit --print-file compilers)"
  fi
fi
EORUN


# Install an environment with our base libraries using the compiler ref we just generated
COPY <<'EOCOPY' spack.yaml
spack:
  view: false
  definitions:
  - buildeps: []
  - compiler: []
  - libs: []
  - mpi: []
  - mpilibs: []
  specs:
  - '$buildeps'
  - matrix:
    - ['$%compiler']
    - - '$libs'
      - '$mpi'
  - matrix:
    - ['$%compiler']
    - ['$^mpi']
    - ['$mpilibs']
EOCOPY
RUN spack env create pdienv spack.yaml
COPY deps.sh deps.sh
RUN . deps.sh && spack -e pdienv add -l buildeps ${BASE_BUILDDEPS}
RUN . deps.sh && spack -e pdienv add -l libs     ${BASE_LIBS}
RUN <<EORUN
set -e
if ( spack --version | grep -qs '^1\.' )
then spack -e pdienv add -l compiler pditoolchain
else spack -e pdienv add -l compiler "$(spack compilers | tr ' ' '\n' | grep @)"
fi
EORUN
RUN spack -e pdienv concretize --reuse
RUN spack -e pdienv fetch \
 || spack -e pdienv fetch \
 || spack -e pdienv fetch \
 || spack -e pdienv fetch \
 || spack -e pdienv fetch
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS}
