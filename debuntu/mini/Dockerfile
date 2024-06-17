ARG DISTRO
ARG DISTRO_VERSION

FROM ${DISTRO}:${DISTRO_VERSION} AS main

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG DISTRO
ARG DISTRO_VERSION
ARG MPI

ENV DOCKERFILE_BASE=${DISTRO}
ENV DOCKERFILE_DISTRO=${DISTRO}
ENV DOCKERFILE_DISTRO_VERSION=${DISTRO_VERSION}
ENV HOME=/root
ENV container=docker

WORKDIR ${HOME}

COPY bash_run /bin/

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash_run"]
CMD ["bash", "-i"]

RUN set -ex \
 && if [ -f /etc/os-release ]; then . /etc/os-release; fi \
 && chmod +x /bin/bash_run \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get upgrade -y \
 && if [[ "${MPI}" = openmpi ]]; then MPI4PY=python3-mpi4py; fi \
 && apt-get install -y --no-install-recommends \
            bison \
            build-essential \
            cmake \
            curl \
            flex \
            freeglut3-dev \
            gfortran \
            graphviz \
            libglew-dev \
            libgraphviz-dev \
            libhwloc-dev \
            lib${MPI}-dev \
            libssl-dev \
            libxi-dev \
            libxml2-dev \
            libxmu-dev \
            libxslt1-dev \
            m4 \
            mesa-common-dev \
            "${MPI/openmpi/openmpi-bin}" \
            pkg-config \
            python3-dev \
            ${MPI4PY} \
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
 && ldconfig \
 && useradd -d /home/ci -m -U ci \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /run/nologin \
 && rm -rf /root/* \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )

ENV PDI_SYSTEM=${DISTRO}-${DISTRO_VERSION}
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

RUN curl --output pdi.tar.bz2 https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/builderv3/pdi.tar.bz2
RUN tar -xf pdi.tar.bz2
RUN export VERBOSE=1 \
 && export MAKEFLAGS="-j1" \
 && bash pdi*/tools/build_scripts/build_and_run.sh



FROM main
