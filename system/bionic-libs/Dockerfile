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
 && apt-get install -y --no-install-recommends \
            astyle \
            build-essential \
            cmake \
            doxygen \
            flowvr \
            gfortran \
            libfti-${MPI}-dev \
            libhdf5-${MPI}-dev \
            libnetcdf-dev \
            libparaconf-dev \
            libsion-${MPI}-dev \
            libspdlog-dev \
            libyaml-dev \
            "${MPI/openmpi/openmpi-bin}" \
            pdidev-archive-keyring \
            pkg-config \
            pybind11-dev \
            python3-dev \
            python3-numpy \
            python3-pip \
            python3-setuptools \
            python3-yaml \
            ssh-client \
            zpp \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /run/nologin \
 && rm -rf /root/* \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true ) \
 && pip3 install --no-cache-dir mpi4py \
 && ldconfig

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


FROM main AS test

#TODO: Integrate into main branch
RUN curl --output pdi-fix_398.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/fix_398/pdi-fix_398.tar.gz
RUN tar -xf pdi-fix_398.tar.gz

RUN export MAKEFLAGS="-j 1" \
 && bash pdi-fix_398/tools/build_scripts/build_and_run.sh


FROM main
