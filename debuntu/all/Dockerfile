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
 && apt-get install -y --no-install-recommends \
            apt-transport-https \
            ca-certificates \
            curl \
 && echo "deb [ arch=amd64 ] https://raw.githubusercontent.com/pdidev/repo/pdi-master.${DISTRO} ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/pdi.list \
 && curl --output /etc/apt/trusted.gpg.d/pdidev-archive-keyring.gpg https://raw.githubusercontent.com/pdidev/repo/pdi-master.${DISTRO}/pdidev-archive-keyring.gpg \
 && apt-get update -y \
 && if [[ "${MPI}" = openmpi ]]; then MPI4PY=python3-mpi4py; fi\
 && apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            doxygen \
            gfortran \
            libhdf5-${MPI}-dev \
            libnetcdf-mpi-dev \
            libparaconf-dev \
            libspdlog-dev \
            libyaml-dev \
            "${MPI/openmpi/openmpi-bin}" \
            pdidev-archive-keyring \
            pkg-config \
            pybind11-dev \
            python3-dev \
            ${MPI4PY} \
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
 && ldconfig

ENV PDI_SYSTEM=${DISTRO}-${DISTRO_VERSION}
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

RUN curl --output pdi-master.tar.bz2 https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/master/pdi-master.tar.bz2
RUN tar -xf pdi-master.tar.bz2
RUN export VERBOSE=1 \
 && export MAKEFLAGS="-j1" \
 && bash pdi-master/tools/build_scripts/build_and_run.sh



FROM main
