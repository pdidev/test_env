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
            git \
            apt-transport-https \
            ca-certificates \
            curl \
 && echo "deb [ arch=amd64 ] https://repo.pdi.dev/pdi-main.${DISTRO} ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/pdi.list \
 && curl --output /etc/apt/trusted.gpg.d/pdidev-archive-keyring.gpg https://repo.pdi.dev/pdi-main.${DISTRO}/pdidev-archive-keyring.gpg \
 && apt-get update -y \
 && if [[ "${MPI}" = openmpi ]]; then MPI4PY=python3-mpi4py; FLOWVR=flowvr; fi\
 && apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            libboost-dev \
            libssl-dev \
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

# stage : veloc download 

FROM main AS velocdl

RUN if pip3 install --help | grep -q -- --break-system-packages; then \
      pip3 install --break-system-packages beautifulsoup4 wget; \
    else \
      pip3 install beautifulsoup4 wget; \
    fi

WORKDIR /usr/veloc-src
RUN git clone https://github.com/ECP-VeloC/VELOC.git . \
    && mkdir -p /usr/local \
    && python3 auto-install.py /usr/local

# stage : mpich download enabling options for shared memory support 
# shared mem support is needed for VeloC  
FROM main AS mpichdl
ARG MPI
ARG DISTRO
ARG DISTRO_VERSION

RUN set -ex \
 && if [ "${MPI}" = "mpich" ] && [ "${DISTRO}" = "debian" ] && [ "${DISTRO_VERSION}" = "unstable" ]; then \
      apt-get update -y \
      && apt-get install -y --no-install-recommends dpkg-dev \
      && printf "Types: deb-src\nURIs: http://deb.debian.org/debian\nSuites: ${DISTRO_VERSION}\nComponents: main\n" \
         > /etc/apt/sources.list.d/debian-src.sources \
      && apt-get update -y \
      && apt-get source mpich \
      && cd mpich-* \
      && ./configure \
           --prefix=/usr/local \
           --with-ch4-shmmods=posix \
           --with-device=ch4:ucx \
           --enable-shared \
           --disable-static \
           FC=gfortran \
      && make -j$(nproc) \
      && make install \
      && ldconfig; \
    fi

# stage : complete image

FROM main AS complete-main
ARG DISTRO
ARG DISTRO_VERSION
ARG MPI
COPY --from=velocdl /usr/local /usr/local_veloc
COPY --from=mpichdl /usr/local /usr/local_mpich
RUN if [ "${MPI}" = "mpich" ] && [ "${DISTRO}" = "debian" ] && [ "${DISTRO_VERSION}" = "unstable" ]; then \
      cp -a /usr/local_mpich/. /usr/local/ \
      && rm -rf /usr/local_mpich; \
    else \
      rm -rf /usr/local_mpich; \
    fi
RUN printf "/usr/local_veloc/lib" > /etc/ld.so.conf.d/veloc.conf \
    && ldconfig

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

# stage : pdi download 

FROM alpine/git AS pdidl

RUN git -C /root clone --recurse-submodules https://github.com/pdidev/pdi.git /root/pdi

# stage : test 

FROM complete-main AS test

COPY --from=pdidl --chown=ci:ci /root/pdi /home/ci/pdi

RUN export VERBOSE=1 \
 && bash pdi/bin/build_and_run_all_tests

FROM complete-main
