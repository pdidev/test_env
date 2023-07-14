FROM ubuntu:20.04

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ENV DOCKERFILE_BASE=ubuntu          \
    DOCKERFILE_DISTRO=ubuntu        \
    DOCKERFILE_DISTRO_VERSION=20.04 \
    DEBIAN_FRONTEND=noninteractive  \
    HOME=/root                      \
    LC_ALL=C                        \
    LANG=C                          \
    SPACK_INSTALL=/opt/install      \
    SPACK_MODULES=/opt/modules      \
    SPACK_ROOT=/opt/spack           \
    container=docker


WORKDIR ${HOME}


RUN set -ex \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            environment-modules \
            gfortran \
            libstdc++-9-dev \
            make \
            tcl \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && useradd -d /home/ci -m -U ci \
 && rm -rf /var/lib/apt/lists/* /run/nologin \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )
