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
            curl \
            libspdlog-dev \
            libboost-dev \
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
 && curl -Lo /tmp/doxygen.tar.gz \
      https://github.com/doxygen/doxygen/releases/download/Release_1_9_8/doxygen-1.9.8.linux.bin.tar.gz \
 && tar -xzf /tmp/doxygen.tar.gz -C /usr/local --strip-components=1 \
 && rm /tmp/doxygen.tar.gz \
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

RUN set -ex \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends \
            git \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/*

RUN set -ex \
 && git clone --depth 1 -b v1.4.0 https://github.com/ECP-VeloC/KVTree.git /tmp/kvtree \
 && cmake -S /tmp/kvtree -B /tmp/kvtree/build \
          -DENABLE_TESTS=OFF \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
 && cmake --build /tmp/kvtree/build --parallel \
 && cmake --install /tmp/kvtree/build \
 && rm -rf /tmp/kvtree

RUN set -ex \
 && git clone --depth 1 -b v0.8.0 https://github.com/ECP-VeloC/AXL.git /tmp/axl \
 && cmake -S /tmp/axl -B /tmp/axl/build \
          -DENABLE_TESTS=OFF \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
 && cmake --build /tmp/axl/build --parallel \
 && cmake --install /tmp/axl/build \
 && rm -rf /tmp/axl

RUN set -ex \
 && git clone --depth 1 -b v0.3.0 https://github.com/ECP-VeloC/rankstr.git /tmp/rankstr \
 && cmake -S /tmp/rankstr -B /tmp/rankstr/build \
          -DENABLE_TESTS=OFF \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
 && cmake --build /tmp/rankstr/build --parallel \
 && cmake --install /tmp/rankstr/build \
 && rm -rf /tmp/rankstr

RUN set -ex \
 && git clone --depth 1 -b v0.3.0 https://github.com/ECP-VeloC/redset.git /tmp/redset \
 && cmake -S /tmp/redset -B /tmp/redset/build \
          -DENABLE_TESTS=OFF \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
 && cmake --build /tmp/redset/build --parallel \
 && cmake --install /tmp/redset/build \
 && rm -rf /tmp/redset

RUN set -ex \
 && git clone --depth 1 -b v0.3.0 https://github.com/ECP-VeloC/shuffile.git /tmp/shuffile \
 && cmake -S /tmp/shuffile -B /tmp/shuffile/build \
          -DENABLE_TESTS=OFF \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
 && cmake --build /tmp/shuffile/build --parallel \
 && cmake --install /tmp/shuffile/build \
 && rm -rf /tmp/shuffile

RUN set -ex \
 && git clone --depth 1 -b v0.4.0 https://github.com/ECP-VeloC/er.git /tmp/er \
 && cmake -S /tmp/er -B /tmp/er/build \
          -DENABLE_TESTS=OFF \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
 && cmake --build /tmp/er/build --parallel \
 && cmake --install /tmp/er/build \
 && rm -rf /tmp/er

RUN set -ex \
 && git clone --depth 1 -b 'veloc-1.8' https://github.com/ECP-VeloC/veloc.git /tmp/veloc \
 && cmake -S /tmp/veloc -B /tmp/veloc/build \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DCOMM_QUEUE=socket_queue \
          -DENABLE_TESTS=OFF \
          -DCMAKE_CXX_FLAGS="-DOMPI_SKIP_MPICXX=1" \
 && cmake --build /tmp/veloc/build --parallel \
 && cmake --install /tmp/veloc/build \
 && rm -rf /tmp/veloc

# stage : mpich download (with options for shared memory support)

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
COPY --from=velocdl /usr/local /usr/local
COPY --from=mpichdl /usr/local /usr/local_mpich
RUN if [ "${MPI}" = "mpich" ] && [ "${DISTRO}" = "debian" ] && [ "${DISTRO_VERSION}" = "unstable" ]; then \
      cp -a /usr/local_mpich/. /usr/local/ \
      && rm -rf /usr/local_mpich; \
    else \
      rm -rf /usr/local_mpich; \
    fi
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/veloc.conf && ldconfig

ENV PDI_SYSTEM=${DISTRO}
ENV PDI_COMPILER=gcc
ENV PDI_MPI=${MPI}
# only required for openmpi but...
ENV OMPI_MCA_rmaps_base_oversubscribe=1
ENV PRTE_MCA_rmaps_default_mapping_policy=:oversubscribe

ENV HOME=/home/ci
USER ci:ci
WORKDIR ${HOME}

# stage : pdi download 

FROM alpine/git AS pdidl

RUN git -C /root clone --recurse-submodules --branch cp-plugin https://github.com/iole-bolognesi/pdi.git /root/pdi

# stage : test 

FROM complete-main AS test

COPY --from=pdidl --chown=ci:ci /root/pdi /home/ci/pdi

RUN export VERBOSE=1 \
 && bash pdi/bin/build_and_run_all_tests

FROM complete-main
