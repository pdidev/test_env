ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ENV CURRENTLY_BUILDING_DOCKER_IMAGE=1

RUN mkdir -p ${SPACK_ROOT}
RUN git clone --depth 1 https://github.com/spack/spack.git ${SPACK_ROOT}
RUN rm -rf ${SPACK_ROOT}/.git
 
SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]

RUN mkdir -p ${SPACK_HOME}
RUN spack external find --not-buildable
RUN spack spec hdf5+mpi
RUN spack reindex
RUN spack config add "packages:all:target:[x86_64]"
RUN sed 's/target:.*/target: x86_64/' -i ${SPACK_HOME}/linux/compilers.yaml
