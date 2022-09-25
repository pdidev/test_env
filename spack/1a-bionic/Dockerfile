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
            ca-certificates \
            gfortran \
            git \
            locales \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* /run/nologin \
 && locale-gen ${LC_ALL} \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )
