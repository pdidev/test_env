FROM ubuntu:18.04

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ENV DOCKERFILE_BASE=ubuntu            \
    DOCKERFILE_DISTRO=ubuntu          \
    DOCKERFILE_DISTRO_VERSION=18.04   \
    DEBIAN_FRONTEND=noninteractive    \
    HOME=/root                        \
    LANG=en_US.UTF-8                  \
    LANGUAGE=en_US.UTF-8              \
    LC_ALL=en_US.UTF-8                \
    SPACK_ROOT=/opt/spack             \
    container=docker
ENV SPACK_HOME=${HOME}/.spack

WORKDIR ${HOME}

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
            libcurl4-openssl-dev \
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
 && rm -rf /var/lib/apt/lists/* /run/nologin \
 && locale-gen ${LC_ALL} \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true ) \
 && pip3 --no-cache-dir install boto3 \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/docker-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/interactive-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/spack-env
