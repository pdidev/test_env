ARG DISTRO
ARG DISTRO_VERSION

FROM ${DISTRO}:${DISTRO_VERSION} AS base_main

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
 && echo "deb [ arch=amd64 ] https://repo.pdi.dev/pdi-main.${DISTRO} ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/pdi.list \
 && curl --output /etc/apt/trusted.gpg.d/pdidev-archive-keyring.gpg https://repo.pdi.dev/pdi-main.${DISTRO}/pdidev-archive-keyring.gpg \
 && apt-get update -y \
 && if [[ "${MPI}" = openmpi ]]; then MPI4PY=python3-mpi4py; FLOWVR=flowvr; fi \
 && apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            doxygen \
            gfortran \
            libhdf5-${MPI}-dev \
            lib${MPI}-dev \
            libnetcdf-dev \
            libparaconf-dev \
            libspdlog-dev \
            libyaml-dev \
            "${MPI/openmpi/openmpi-bin}" \
            ${MPI4PY} \
            pdidev-archive-keyring \
            pkg-config \
            pybind11-dev \
            python3-dev \
            python3-numpy \
            python3-pip \
            python3-setuptools \
            python3-venv \
            python3-yaml \
            openssh-client \
 && apt-get purge -y curl \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && useradd -d /home/ci -m -U ci \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /run/nologin \
 && rm -rf /root/* \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )

# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1
ENV PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe
# force parallel HDF5 as first try (see #43)
ENV HDF5_DIR=/usr/lib/x86_64-linux-gnu/cmake/hdf5_${MPI}

FROM base_main AS builder_catalyst

ARG CATALYST_VERSION
ARG CMAKE_MINIMAL_VERSION_FOR_CATALYST

RUN mkdir -p /opt
# create user ci
ENV HOME=/opt
WORKDIR ${HOME}

RUN set -ex \
&& export DEBIAN_FRONTEND=noninteractive \
&& apt-get update -y \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        git \
        ninja-build \
        curl \
&& rm -rf /var/lib/apt/lists/*

RUN <<EORUN
set -ex
cmake_catalyst_required=${CMAKE_MINIMAL_VERSION_FOR_CATALYST}
cmake_installed=$(cmake --version | head -1 | cut -f3 -d" ")

mapfile -t sorted < <(printf "%s\n" "$cmake_installed" "$cmake_catalyst_required" | sort -V)

cmake_exec=cmake
if [[ ${sorted[0]} == "${cmake_catalyst_required}" ]]; then
    cmake_exec=cmake
else
    curl -LfsSo cmake-bin.tar.gz "https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4-linux-x86_64.tar.gz"
    tar -xf cmake-bin.tar.gz
    cmake_exec=${HOME}/cmake-3.26.4-linux-x86_64/bin/cmake
fi

git clone --branch v${CATALYST_VERSION} \
        --single-branch \
        https://gitlab.kitware.com/paraview/catalyst.git \
        ${HOME}/catalyst_clone/
cd ${HOME}/catalyst_clone/
mkdir build
git submodule update --depth=1 --init --recursive

cmake_exec -GNinja -DCATALYST_BUILD_TESTING:BOOL=OFF \
    -DCATALYST_USE_MPI:BOOL=ON \
    -DCATALYST_WRAP_FORTRAN:BOOL=OFF \
    -DCATALYST_WRAP_PYTHON:BOOL=ON \
    -DCMAKE_INSTALL_PREFIX:PATH=/opt/catalyst/ \
    -S ${HOME}/catalyst_clone/ -B ${HOME}/catalyst_clone/build
cmake_exec --build ${HOME}/catalyst_clone/build  
cmake_exec --install ${HOME}/catalyst_clone/build
EORUN

FROM base_main as main

ARG DISTRO
ARG DISTRO_VERSION
ARG MPI

ENV PDI_SYSTEM=${DISTRO}-${DISTRO_VERSION}
ENV PDI_COMPILER=gcc
ENV PDI_MPI=${MPI}
ENV PDI_LIBS=provided
# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1
ENV PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe

## add catalyst
COPY --from=builder_catalyst /opt/catalyst /opt/catalyst
ENV catalyst_DIR="/opt/catalyst/lib/cmake/catalyst-2.0"
RUN echo "/opt/catalyst/lib" > /etc/ld.so.conf.d/image_catalyst.conf \
&& ldconfig

# create user ci
ENV HOME=/home/ci
USER ci:ci
WORKDIR ${HOME}

FROM alpine/git AS pdidl

#RUN git -C /root clone --recurse-submodules https://github.com/pdidev/pdi.git /root/pdi
RUN git -C /root clone -b catalyst-plugin --recurse-submodules https://github.com/francois-kitware/pdi /root/pdi

FROM main AS test

COPY --from=pdidl --chown=ci:ci /root/pdi /home/ci/pdi

RUN export VERBOSE=1 \
 && bash pdi/bin/build_and_run_all_tests

FROM main
