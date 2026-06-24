ARG VERSION
ARG COMPILER
ARG MPI
ARG LIBS
ARG IMAGE_TAG
ARG REGISTRY=ghcr.io/pdidev/test_env

FROM ${REGISTRY}/builder:${VERSION}-${COMPILER}-${MPI}-${LIBS}-${IMAGE_TAG} AS builder

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


# Remove all packages that are not part of our environment (except for the compiler)
RUN <<EORUN
set -e
if ( spack --version | grep -qs '^1\.' )
then
  spack -e pdienv add "$(cat compilerpkg.lst)%gcc"
  spack -e pdienv concretize --reuse
  spack gc -ye pdienv
else
  spack mark -ai
  spack mark -e "$(cat compilerpkg.lst)%gcc"
  for H in $(spack -e pdienv find --format '{/hash}')
    do spack mark -e "$H"
  done
  spack gc -y
  spack compiler find /usr
fi
EORUN


# Strip everything to reduce size
RUN find -L ${SPACK_INSTALL} -type f -exec file -i '{}' '+' \
  | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s


ARG COMPILER
ARG MPI
ARG LIBS

# Start our init script with some info about the image version
COPY <<EOCOPY /bin/bash_run
#!/bin/bash
. /usr/share/modules/init/bash
MODULEPATH=${SPACK_MODULES}
export PDI_SYSTEM=spack
export PDI_COMPILER=${COMPILER}
export PDI_MPI=${MPI}
EOCOPY
RUN <<EORUN
set -e
if [[ "xopenmpi" = "x${MPI}" ]]
then
  echo 'export OMPI_MCA_rmaps_base_oversubscribe=1' >> /bin/bash_run
  echo 'export PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe' >> /bin/bash_run
fi
if [[ "xall" = "x${LIBS}" ]]
then echo 'export PDI_LIBS=provided' >> /bin/bash_run
fi
if [[ "x$COMPILER" = 'xclang' ]]
then echo "export FC=gfortran" >> /bin/bash_run
fi
EORUN


# Generate the modules and load them from the init script
RUN <<EORUN
set -e
spack config add 'modules:prefix_inspections:lib64:[LD_LIBRARY_PATH]'
spack config add 'modules:prefix_inspections:lib:[LD_LIBRARY_PATH]'
spack config add 'modules:default:tcl:all:autoload:direct'
spack config add 'modules:default:arch_folder:false'
EORUN
RUN spack module tcl refresh --delete-tree -y
RUN <<EORUN
set -e
if ! ( spack --version | grep -qs '^1\.' )
then
  echo "module load $(spack module tcl find "$(cat compilerpkg.lst)%gcc")" >> /bin/bash_run
fi
EORUN
RUN cat "$(spack -e pdienv env loads | grep source | awk '{print $2}')" >> /bin/bash_run


# Finalize our init script
RUN echo 'exec "$@"' >> /bin/bash_run


# Remove useless spack files before squashing
RUN spack clean -a





FROM ${REGISTRY}/base:${IMAGE_TAG} AS main

COPY --from=builder ${SPACK_INSTALL} ${SPACK_INSTALL}
COPY --from=builder ${SPACK_MODULES} ${SPACK_MODULES}
COPY --from=builder --chmod=755 /bin/bash_run /bin/bash_run


ARG COMPILER

# use system gfortran for clang that doesn't support fortran
RUN <<EORUN
set -e
export DEBIAN_FRONTEND=noninteractive
if echo "$COMPILER" | grep -q clang
then
  apt-get update -y
  apt-get upgrade -y
  apt-get install -y --no-install-recommends gfortran
  apt-get autoremove -y --purge
  apt-get clean -y
  apt-get autoclean -y
  rm -rf /var/lib/apt/lists/*
fi
EORUN


USER ci:ci
WORKDIR /home/ci
ENV HOME=/home/ci


SHELL ["/bin/bash_run", "bash", "-c"]
ENTRYPOINT ["/bin/bash_run"]
CMD ["bash", "-i"]





FROM ${REGISTRY}/spackbase:${IMAGE_TAG} AS fullspack


COPY --from=builder --chown=ci:ci ${SPACK_INSTALL} ${SPACK_INSTALL}
COPY --from=builder --chown=ci:ci ${SPACK_MODULES} ${SPACK_MODULES}
COPY --from=builder --chown=ci:ci ${SPACK_ROOT} ${SPACK_ROOT}


SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]


USER ci:ci
WORKDIR /home/ci
ENV HOME=/home/ci





FROM alpine/git AS pdidl

RUN git -C /root clone --recurse-submodules https://github.com/pdidev/pdi.git /root/pdi

FROM main AS test

COPY --from=pdidl --chown=ci:ci /root/pdi /home/ci/pdi

RUN export VERBOSE=1 \
 && bash pdi/bin/build_and_run_all_tests

FROM main
