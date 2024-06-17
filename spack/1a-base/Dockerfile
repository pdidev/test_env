FROM ubuntu:20.04

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ENV DOCKERFILE_BASE=ubuntu
ENV DOCKERFILE_DISTRO=ubuntu
ENV DOCKERFILE_DISTRO_VERSION=22.04
ENV HOME=/root
ENV LC_ALL=C
ENV LANG=C
ENV SPACK_INSTALL=/opt/install
ENV SPACK_MODULES=/opt/modules
ENV SPACK_ROOT=/opt/spack
ENV container=docker


WORKDIR ${HOME}


RUN set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            environment-modules \
            gfortran \
            libstdc++-7-dev \
            make \
            tcl \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && useradd -d /home/ci -m -U ci \
 && rm -rf /var/lib/apt/lists/* /run/nologin \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )
