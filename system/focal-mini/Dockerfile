FROM ubuntu:20.04 AS main

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG MPI

ENV DOCKERFILE_BASE=ubuntu            \
    DOCKERFILE_DISTRO=ubuntu          \
    DOCKERFILE_DISTRO_VERSION=20.04   \
    HOME=/root                        \
    container=docker

WORKDIR ${HOME}

COPY bash_run /bin/

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash_run"]
CMD ["bash", "-i"]

RUN set -ex \
 && chmod +x /bin/bash_run \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get upgrade -y \
 && echo tzdata tzdata/Areas string Etc | debconf-set-selections \
 && echo tzdata tzdata/Zones/Etc string UTC | debconf-set-selections \
 && apt-get install -y --no-install-recommends \
            apt-transport-https \
            bison \
            build-essential \
            cmake \
            flex \
            freeglut3-dev \
            gfortran \
            graphviz \
            libglew-dev \
            libgraphviz-dev \
            lib${MPI}-dev \
            libhwloc-dev \
            libssl-dev \
            libxi-dev \
            libxml2-dev \
            libxmu-dev \
            libxslt1-dev \
            m4 \
            mesa-common-dev \
            "${MPI/openmpi/openmpi-bin}" \
            pkg-config \
            python3-all \
            python3-dev \
            python3-numpy \
            python3-pip \
            python3-setuptools \
            python3-venv \
            python3-yaml \
            ssh-client \
            swig \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && pip3 install --no-cache-dir mpi4py \
 && ldconfig \
 && useradd -d /home/ci -m -U ci \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /run/nologin \
 && rm -rf /root/* \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )

ENV PDI_SYSTEM=ubuntu-focal
ENV PDI_COMPILER=gcc
ENV PDI_MPI=${MPI}
# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1

USER ci:ci
WORKDIR /home/ci
ENV HOME /home/ci


FROM main AS test

USER root:root
WORKDIR /root
ENV HOME /root

RUN set -ex \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl

USER ci:ci
WORKDIR /home/ci
ENV HOME /home/ci

RUN curl --output pdi-master.tar.bz2 https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/master/pdi-master.tar.bz2
RUN tar -xf pdi-master.tar.bz2
RUN export VERBOSE=1 \
 && export MAKEFLAGS="-j1" \
 && bash pdi-master/tools/build_scripts/build_and_run.sh


FROM main
