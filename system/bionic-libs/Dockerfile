FROM ubuntu:18.04

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG MPI
ARG PDI_VERSION

ENV DOCKERFILE_BASE=ubuntu            \
    DOCKERFILE_DISTRO=ubuntu          \
    DOCKERFILE_DISTRO_VERSION=18.04   \
    HOME=/root                        \
    container=docker

WORKDIR ${HOME}

COPY bash_run /bin/

RUN set -ex \
 && chmod +x /bin/bash_run \
 && DEBIAN_FRONTEND=noninteractive    \
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
            build-essential \
            cmake \
            flowvr \
            gfortran \
            libfti-${MPI}-dev \
            libhdf5-${MPI}-dev \
            libnetcdf-dev \
            libparaconf-dev \
            libsion-${MPI}-dev \
            libspdlog-dev \
            pdidev-archive-keyring \
            pkg-config \
            pybind11-dev \
            python3-dev \
            python3-numpy \
            python3-yaml \
            zpp \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /run/nologin \
 && rm -rf /root/* \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )

ENV PDI_SYSTEM=ubuntu-bionic
ENV PDI_DEPS=${VERSION}
ENV PDI_COMPILER=${COMPILER}
ENV MPI_LIB=${MPI}
ENV PDI_MPI=${MPI}
ENV PDI_LIBS=provided
# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1

RUN useradd -d /home/ci -m -U ci
ENV HOME=/home/ci

USER ci:ci
WORKDIR ${HOME}

ENV BASH_ENV=/etc/profile
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash_run"]
CMD ["bash", "-i"]
