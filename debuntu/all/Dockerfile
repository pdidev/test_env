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
            ssh-client \
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
ENV PDI_LIBS=provided
# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1
ENV PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe

ENV HOME=/home/ci
USER ci:ci
WORKDIR ${HOME}

FROM main AS builder_catalyst
USER root

ARG CATALYST_VERSION
ARG CMAKE_MINIMAL_VERSION_FOR_CATALYST

RUN <<EORUN
set -ex
cmake_catalyst_required=${CMAKE_MINIMAL_VERSION_FOR_CATALYST}
cmake_installed=$(cmake --version | head -1 | cut -f3 -d" ")

mapfile -t sorted < <(printf "%s\n" "$cmake_installed" "$cmake_catalyst_required" | sort -V)

if [[ ${sorted[0]} == "$cmake_catalyst_required" ]]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y --no-install-recommends \
            apt-transport-https \
            ca-certificates \
            git \
            ninja-build
    rm -rf /var/lib/apt/lists/*

    git clone --branch v${CATALYST_VERSION} \
            --single-branch \
            https://gitlab.kitware.com/paraview/catalyst.git \
            ${HOME}/catalyst_clone/
    cd ${HOME}/catalyst_clone/
    mkdir build
    git submodule update --depth=1 --init --recursive
    cmake -GNinja -DCATALYST_BUILD_TESTING:BOOL=OFF \
        -DCATALYST_USE_MPI:BOOL=ON \
        -DCATALYST_WRAP_FORTRAN:BOOL=OFF \
        -DCATALYST_WRAP_PYTHON:BOOL=ON \
        -DCMAKE_INSTALL_PREFIX:PATH=/opt/catalyst/ \
        -S ${HOME}/catalyst_clone/ -B ${HOME}/catalyst_clone/build
    cmake --build ${HOME}/catalyst_clone/build  
    cmake --install ${HOME}/catalyst_clone/build
else
    mkdir -p /opt/catalyst
fi
EORUN

FROM alpine/git AS pdidl

#RUN git -C /root clone --recurse-submodules https://github.com/pdidev/pdi.git /root/pdi
RUN git -C /root clone -b catalyst-plugin --recurse-submodules https://github.com/francois-kitware/pdi /root/pdi

FROM main AS test
USER ci
COPY --from=pdidl --chown=ci:ci /root/pdi /home/ci/pdi
COPY --from=builder_catalyst --chown=ci:ci /opt/catalyst /opt/catalyst

WORKDIR ${HOME}
## Add env varible for catalyst lib
ENV LD_LIBRARY_PATH="/opt/catalyst/lib"
ENV catalyst_dir="/opt/catalyst/lib/cmake/catalyst-2.0"

RUN export VERBOSE=1 \
 && bash pdi/bin/build_and_run_all_tests



FROM main
