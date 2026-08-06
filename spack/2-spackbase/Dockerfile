ARG IMAGE_TAG
ARG REGISTRY=ghcr.io/pdidev/test_env

FROM ${REGISTRY}/base:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ENV SPACK_ROOT=/opt/spack
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8


RUN set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            ca-certificates \
            build-essential \
            curl \
            file \
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
            unzip \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && locale-gen ${LC_ALL} \
 && rm -rf /var/lib/apt/lists/* /run/nologin \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/docker-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/interactive-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/spack-env
