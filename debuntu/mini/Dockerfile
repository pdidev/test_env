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

ENV PDI_SYSTEM=${DISTRO}-${DISTRO_VERSION}
ENV PDI_COMPILER=gcc
ENV PDI_MPI=${MPI}
# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1
ENV PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe

ENV HOME=/home/ci
USER ci:ci
WORKDIR ${HOME}

## chmod -R o+rX .
FROM main AS builder_catalyst
USER root
RUN set -ex \
&& export DEBIAN_FRONTEND=noninteractive \
&& apt-get update -y \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
            apt-transport-https \
            ca-certificates \
            git \
            ninja-build \
&& rm -rf /var/lib/apt/lists/*

# copy file for building and installing catalyst
COPY cmake_catalyst.sh ${HOME}
COPY build_catalyst.sh ${HOME}
COPY install_catalyst.sh ${HOME}

RUN chmod +x /home/ci/cmake_catalyst.sh
RUN chmod +x /home/ci/build_catalyst.sh
RUN chmod +x /home/ci/install_catalyst.sh

RUN chown ci /home/ci/cmake_catalyst.sh
RUN chown ci /home/ci/build_catalyst.sh

RUN set -ex && bash /home/ci/cmake_catalyst.sh

USER ci
RUN set -ex && bash /home/ci/build_catalyst.sh

USER root
RUN set -ex && bash /home/ci/install_catalyst.sh

USER ci

FROM alpine/git AS pdidl

#RUN git -C /root clone --recurse-submodules https://github.com/pdidev/pdi.git /root/pdi
RUN git -C /root clone -b catalyst-plugin --recurse-submodules https://github.com/francois-kitware/pdi /root/pdi

FROM main AS test

COPY --from=pdidl --chown=ci:ci /root/pdi /home/ci/pdi
COPY --from=builder_catalyst --chown=ci:ci /opt/catalyst /opt/catalyst

WORKDIR ${HOME}
## Add env varible for catalyst lib
ENV LD_LIBRARY_PATH="/opt/catalyst/lib"
ENV catalyst_dir="/opt/catalyst/lib/cmake/catalyst-2.0"
## add to check if catalyst_dir is needed

RUN export VERBOSE=1 \
 && bash pdi/bin/build_and_run_all_tests

FROM main
