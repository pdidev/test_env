ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ENV CURRENTLY_BUILDING_DOCKER_IMAGE=1

RUN set -ex \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            build-essential \
            curl \
            file \
            g++ \
            gcc \
            gnupg2 \
            iproute2 \
            libcurl4-openssl-dev \
            libssl-dev \
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
 && pip3 --no-cache-dir install boto3 \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/docker-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/interactive-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/spack-env

RUN mkdir -p ${SPACK_ROOT}
RUN git clone --depth 1 https://github.com/spack/spack.git ${SPACK_ROOT} \
 && rm -rf ${SPACK_ROOT}/.git

RUN mv $SPACK_ROOT/share/spack/setup-env.sh $SPACK_ROOT/share/spack/setup-env-orig.sh
RUN mkdir -p $SPACK_ROOT/etc/env
COPY setup-env.sh ${SPACK_ROOT}/share/spack/setup-env.sh

SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]

RUN mkdir -p ${SPACK_HOME}
RUN spack compiler find --scope site
RUN spack spec hdf5+mpi
RUN spack reindex
RUN spack config --scope site add "packages:all:target:[x86_64]"

COPY spack.yaml spack.yaml
RUN spack env create pdienv spack.yaml
