ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ENV CURRENTLY_BUILDING_DOCKER_IMAGE=1

RUN mkdir -p ${SPACK_ROOT}
RUN git clone --depth 1 https://github.com/spack/spack.git ${SPACK_ROOT}
RUN rm -rf ${SPACK_ROOT}/.git

RUN mv $SPACK_ROOT/share/spack/setup-env.sh $SPACK_ROOT/share/spack/setup-env-orig.sh
RUN mkdir -p $SPACK_ROOT/etc/env
COPY setup-env.sh ${SPACK_ROOT}/share/spack/setup-env.sh

SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]

RUN mkdir -p ${SPACK_HOME}
RUN spack external find --not-buildable
RUN spack spec hdf5+mpi
RUN spack reindex
RUN spack config add "packages:all:target:[x86_64]"

COPY spack.yaml spack.yaml
RUN spack env create pdienv spack.yaml
