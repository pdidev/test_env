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
            bison \
            build-essential \
            ca-certificates \
            cmake \
            curl \
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
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /run/nologin \
 && rm -rf /root/* \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true ) \
 && pip3 install --no-cache-dir mpi4py \
 && ldconfig

ENV PDI_SYSTEM=ubuntu-bionic
ENV PDI_COMPILER=gcc
ENV PDI_MPI=${MPI}
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
