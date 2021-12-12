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
            libssl-dev \
            locales \
            make \
            python3 \
            python3-dev \
            python3-pip \
            python3-setuptools \
            python3-venv \
            tcl \
            unzip \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* /run/nologin

RUN locale-gen ${LC_ALL} \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )

RUN pip3 --no-cache-dir install boto3

RUN mkdir -p ${SPACK_ROOT} \
 && git clone --depth 1 https://github.com/spack/spack.git ${SPACK_ROOT} \
 && rm -rf ${SPACK_ROOT}/.git \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/docker-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/interactive-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/spack-env

ENV HOME=/root
WORKDIR ${HOME}
ENV SPACK_HOME=${HOME}/.spack
SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]

RUN mkdir -p /root/.spack \
 && spack external find --not-buildable \
 && spack spec hdf5+mpi \
 && spack reindex \
 && spack config add "packages:all:target:[x86_64]" \
 && spack clean -a \
 && sed 's/target:.*/target: x86_64/' -i /root/.spack/linux/compilers.yaml
