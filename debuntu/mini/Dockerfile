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
            build-essential \
            cmake \
            doxygen \
            libssl-dev \
            gfortran \
            libcurl4-openssl-dev \
            lib${MPI}-dev \
            libxml2-dev \
            m4 \
            "${MPI/openmpi/openmpi-bin}" \
            ${MPI4PY} \
            pkg-config \
            python3-dev \
            python3-numpy \
            python3-pip \
            python3-setuptools \
            python3-venv \
            python3-yaml \
            ssh-client \
            zlib1g-dev \
 && if dpkg-query -W 'libspdlog1*' > /dev/null; then apt-get install -y --no-install-recommends libspdlog-dev; fi \
 && apt-get purge -y curl \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && useradd -d /home/ci -m -U ci \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /run/nologin \
 && rm -rf /root/* \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )

# stage : veloc download 

FROM main AS velocdl

# install tools needed by VeloC install script 
RUN set -ex \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        git \
        python3-wget \
        python3-bs4 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/src

# Clone VeloC repository
RUN git clone -b 'veloc-1.8' --single-branch --depth 1 \
            https://github.com/ECP-VeloC/veloc.git veloc

WORKDIR /opt/src/veloc

# Run VeloC install script 
RUN mkdir -p /opt/veloc \
      && ./auto-install.py /opt/veloc

# stage : complete image

FROM main AS complete-main
ARG DISTRO
ARG DISTRO_VERSION
ARG MPI

COPY --from=velocdl /opt/veloc /opt/veloc

ENV CMAKE_PREFIX_PATH=/opt/veloc:${CMAKE_PREFIX_PATH}
ENV PDI_SYSTEM=${DISTRO}-${DISTRO_VERSION}
ENV PDI_COMPILER=gcc
ENV PDI_MPI=${MPI}
ENV LD_LIBRARY_PATH="/opt/veloc/lib"
# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1
ENV PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe

ENV HOME=/home/ci
USER ci:ci
WORKDIR ${HOME}

# stage : pdi download 

FROM alpine/git AS pdidl

RUN git -C /root clone --recurse-submodules https://github.com/iole-bolognesi/pdi.git /root/pdi

# stage : test 

FROM complete-main AS test

COPY --from=pdidl --chown=ci:ci /root/pdi /home/ci/pdi

RUN export VERBOSE=1 \
 && bash pdi/bin/build_and_run_all_tests

FROM complete-main
