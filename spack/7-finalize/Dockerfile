ARG VERSION
ARG COMPILER
ARG MPI
ARG LIBS
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-${MPI}-${LIBS}-${IMAGE_TAG} AS builder

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


RUN spack mark -ia \
 && for N in $(spack -e pdienv find --format '{name}' --no-groups -L | awk '{print $1}') \
  ; do spack mark -e "/$N" \
  ; done \
 && spack gc -y \
 && spack clean -a

RUN find -L ${SPACK_INSTALL} -type f -exec file -i '{}' '+' \
  | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

RUN spack config --scope site add 'modules:default:tcl:all:autoload:direct' \
 && spack -e pdienv module tcl refresh --delete-tree -y \
 && spack -e pdienv env loads \
 && spack clean -a


ARG VERSION
ARG COMPILER
ARG MPI
ARG LIBS

RUN echo "export PDI_SYSTEM=spack"> /etc/pdienv.env.sh
RUN echo "export PDI_COMPILER=${COMPILER}" >> /etc/pdienv.env.sh
RUN echo "export PDI_MPI=${MPI}" >> /etc/pdienv.env.sh
RUN if [[ "xopenmpi" = "x${MPI}" ]] \
  ; then echo 'export OMPI_MCA_rmaps_base_oversubscribe=1' >> /etc/pdienv.env.sh \
       ; echo 'export PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe' >> /etc/pdienv.env.sh \
  ; fi
RUN if [[ "xall" = "x${LIBS}" ]] \
  ; then echo 'export PDI_LIBS=provided' >> /etc/pdienv.env.sh \
  ; fi
RUN echo "MODULEPATH=${MODULEPATH}" >> /etc/pdienv.env.sh
RUN if echo "$COMPILER" | grep -q clang \
  ; then echo "export FC=gfortran-10" >> /etc/pdienv.env.sh \
  ; fi



FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG} AS main

COPY --from=builder ${SPACK_INSTALL} ${SPACK_INSTALL}
COPY --from=builder ${SPACK_MODULES} ${SPACK_MODULES}
COPY --from=builder ${SPACK_ROOT}/var/spack/environments/pdienv/loads /etc/pdienv.modules.sh
COPY --from=builder /etc/pdienv.env.sh /etc/pdienv.env.sh


ARG COMPILER

# use system gfortran for clang that doesn't support fortran
RUN set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && if echo "$COMPILER" | grep -q clang \
  ; then \
         apt-get update -y \
      && apt-get upgrade -y \
      && apt-get install -y --no-install-recommends \
                 gfortran-10 \
      && apt-get autoremove -y \
      && apt-get clean -y \
      && apt-get autoclean -y \
      && rm -rf /var/lib/apt/lists/*  \
  ; fi


USER ci:ci
WORKDIR /home/ci
ENV HOME=/home/ci

COPY bash_run /bin/

ENTRYPOINT ["/bin/bash_run"]
SHELL ["/bin/bash_run", "bash", "-c"]
CMD ["/bin/bash_run", "bash", "-i"]



FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG} AS fullspack

ENV LANG=en_US.UTF-8     \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8


COPY --from=builder --chown=ci:ci ${SPACK_INSTALL} ${SPACK_INSTALL}
COPY --from=builder --chown=ci:ci ${SPACK_MODULES} ${SPACK_MODULES}
COPY --from=builder --chown=ci:ci ${SPACK_ROOT} ${SPACK_ROOT}


ARG COMPILER
RUN set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            ca-certificates \
            build-essential \
            curl \
            file \
            git \
            gnupg2 \
            iproute2 \
            libcurl4-openssl-dev \
            libssl-dev \
            locales \
            make \
            python3 \
            python3-dev \
            python3-pip \
            python3-setuptools \
            python3-venv \
            unzip \
 && if echo "$COMPILER" | grep -q clang \
  ; then \
         apt-get install -y --no-install-recommends \
                 gfortran-10 \
  ; fi \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && locale-gen ${LC_ALL} \
 && rm -rf /var/lib/apt/lists/* /run/nologin \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/docker-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/interactive-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/spack-env


USER ci:ci
WORKDIR /home/ci
ENV HOME=/home/ci



FROM main AS test

RUN curl --output pdi.tar.gz https://github.com/pdidev/pdi/archive/refs/heads/main.tar.gz
RUN tar -xf pdi.tar.gz
RUN export VERBOSE=1 \
 && bash pdi*/tools/build_scripts/build_and_run.sh



FROM main
