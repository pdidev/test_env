FROM ubuntu:18.04

ENV DOCKERFILE_BASE=ubuntu            \
    DOCKERFILE_DISTRO=ubuntu          \
    DOCKERFILE_DISTRO_VERSION=18.04   \
    SPACK_ROOT=/opt/spack             \
    DEBIAN_FRONTEND=noninteractive    \
    CURRENTLY_BUILDING_DOCKER_IMAGE=1 \
    container=docker

ENV SPACK_ROOT=/opt/spack

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN set -ex \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        file \
        g++ \
        gcc \
        gfortran \
        git \
        gnupg2 \
        iproute2 \
        locales \
        make \
        python3 \
        python3-pip \
        python3-setuptools \
        tcl \
        unzip \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen ${LC_ALL} \
 && pip3 --no-cache-dir install boto3 \
 && mkdir -p ${SPACK_ROOT} \
 && git clone https://github.com/spack/spack.git ${SPACK_ROOT} \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/docker-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/interactive-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/spack-env \
 && mkdir -p /root/.spack \
 && cp ${SPACK_ROOT}/share/spack/docker/modules.yaml /root/.spack/modules.yaml \
 && rm -rf /root/*.* /run/nologin ${SPACK_ROOT}/.git \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )

WORKDIR /root
SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]

RUN spack spec hdf5+mpi
