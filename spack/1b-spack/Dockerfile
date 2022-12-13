ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION

ENV CURRENTLY_BUILDING_DOCKER_IMAGE=1

ENV LANG=en_US.UTF-8     \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN set -ex \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            ca-certificates \
            build-essential \
            curl \
            file \
            g++ \
            gcc \
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
 && locale-gen ${LC_ALL} \
 && rm -rf /var/lib/apt/lists/* /run/nologin \
 && pip3 --no-cache-dir install boto3 \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/docker-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/interactive-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/spack-env

COPY ${VERSION}.branch spack.branch
RUN mkdir -p ${SPACK_ROOT}
RUN git clone --depth 1 -b $(cat spack.branch) https://github.com/spack/spack.git ${SPACK_ROOT} \
 && rm -rf ${SPACK_ROOT}/.git

SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]

RUN spack compiler find --scope site
RUN spack spec hdf5+mpi
RUN spack reindex
RUN spack config --scope site add 'packages:all:target:[x86_64]'
RUN spack config --scope site add "config:install_tree:root:${SPACK_INSTALL}"
RUN spack config --scope site add 'modules:prefix_inspections:lib64:[LD_LIBRARY_PATH]'
RUN spack config --scope site add 'modules:prefix_inspections:lib:[LD_LIBRARY_PATH]'
RUN spack config --scope site add "modules:default:roots:tcl:${SPACK_MODULES}"

COPY spack.yaml spack.yaml
RUN spack env create pdienv spack.yaml
