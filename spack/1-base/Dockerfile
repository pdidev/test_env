FROM ubuntu:22.04

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ENV LANG=C
ENV LC_ALL=C
ENV HOME=/root
ENV SPACK_INSTALL=/opt/install
ENV SPACK_MODULES=/opt/modules


WORKDIR ${HOME}


RUN set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            binutils \
            environment-modules \
            libstdc++-11-dev \
            make \
            tcl \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && useradd -d /home/ci -m -U ci \
 && rm -rf /var/lib/apt/lists/* /run/nologin \
 && [ -f ~/.profile ] && ( sed -i 's/mesg n/( tty -s \&\& mesg n || true )/g' ~/.profile || true )
