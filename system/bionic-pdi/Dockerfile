FROM ubuntu:18.04 AS main

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG MPI

ENV DOCKERFILE_BASE=ubuntu            \
    DOCKERFILE_DISTRO=ubuntu          \
    DOCKERFILE_DISTRO_VERSION=18.04   \
    HOME=/root                        \
    container=docker

WORKDIR ${HOME}

COPY bash_run /bin/

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash_run"]
CMD ["bash", "-i"]

RUN set -ex \
 && chmod +x /bin/bash_run \
 && DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            apt-transport-https \
            ca-certificates \
            curl \
 && echo "deb [ arch=amd64 ] https://raw.githubusercontent.com/pdidev/repo/pdi-master.ubuntu bionic main" > /etc/apt/sources.list.d/pdi.list \
 && curl --output /etc/apt/trusted.gpg.d/pdidev-archive-keyring.gpg https://raw.githubusercontent.com/pdidev/repo/pdi-master.ubuntu/pdidev-archive-keyring.gpg \
 && apt-get update -y \
 && if [[ "${MPI}" = openmpi ]]; then PDIPLUGIN_FLOWVR=pdiplugin-flowvr; fi\
 && apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            gfortran \
            libpdi-dev \
            "${MPI/openmpi/openmpi-bin}" \
            pdidev-archive-keyring \
            pdiplugin-decl-hdf5-${MPI} \
            pdiplugin-decl-netcdf \
            pdiplugin-decl-sion-${MPI} \
            ${PDIPLUGIN_FLOWVR} \
            pdiplugin-fti-${MPI} \
            pdiplugin-mpi-${MPI} \
            pdiplugin-pycall \
            pdiplugin-serialize \
            pdiplugin-set-value \
            pdiplugin-trace \
            pdiplugin-user-code \
            pkg-config \
            ssh-client \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /run/nologin \
 && rm -rf /root/* \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )

ENV PDI_SYSTEM=ubuntu-bionic
ENV PDI_COMPILER=gcc
ENV PDI_MPI=${MPI}
ENV PDI_LIBS=provided
# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1

RUN useradd -d /home/ci -m -U ci
ENV HOME=/home/ci

USER ci:ci
WORKDIR ${HOME}
