ARG VERSION
ARG COMPILER
ARG MPI
ARG LIBS
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-${MPI}-${LIBS}-${IMAGE_TAG} as builder

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


RUN spack mark -ia \
 && for N in $(spack -e pdienv find --format '{name}' --no-groups -L | awk '{print $1}') \
  ; do spack mark -e "/$N" \
  ; done \
 && spack gc -y \
 && spack clean -a

RUN find -L ${SPACK_INSTALL} -type f -exec file -i '{}' '+' \
  | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

RUN spack config --scope site add 'modules:default:tcl:all:autoload:direct' \
 && spack -e pdienv module tcl refresh --delete-tree -y \
 && spack -e pdienv env loads \
 && spack clean -a


ARG VERSION
ARG COMPILER
ARG MPI
ARG LIBS

RUN touch /etc/pdienv.env.sh
RUN echo "export PDI_SYSTEM=spack" >> /etc/pdienv.env.sh
RUN echo "export PDI_DEPS=${VERSION}" >> /etc/pdienv.env.sh
RUN echo "export PDI_COMPILER=${COMPILER}" >> /etc/pdienv.env.sh
RUN echo "export PDI_MPI=${MPI}" >> /etc/pdienv.env.sh
RUN if [[ "xopenmpi" = "x${MPI}" ]] \
  ; then echo 'export OMPI_MCA_rmaps_base_oversubscribe=1' >> /etc/pdienv.env.sh \
  ; fi
RUN if [[ "xall" = "x${LIBS}" ]] \
  ; then echo 'export PDI_LIBS=provided' >> /etc/pdienv.env.sh \
  ; fi
RUN echo "MODULEPATH=${MODULEPATH}" >> /etc/pdienv.env.sh



FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG} AS main


COPY --from=builder ${SPACK_INSTALL} ${SPACK_INSTALL}
COPY --from=builder ${SPACK_MODULES} ${SPACK_MODULES}
COPY --from=builder ${SPACK_ROOT}/var/spack/environments/pdienv/loads /etc/pdienv.modules.sh
COPY --from=builder /etc/pdienv.env.sh /etc/pdienv.env.sh


USER ci:ci
WORKDIR /home/ci
ENV HOME /home/ci


COPY bash_run /bin/


ENTRYPOINT ["/bin/bash_run"]
SHELL ["/bin/bash_run", "bash", "-c"]
CMD ["/bin/bash_run", "bash", "-i"]



FROM main AS test


USER root:root
WORKDIR /root
ENV HOME /root


RUN set -ex \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl


USER ci:ci
WORKDIR /home/ci
ENV HOME /home/ci


RUN curl --output pdi-deps.tar.bz2 https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/deps/pdi-deps.tar.bz2
RUN tar -xf pdi-deps.tar.bz2
RUN export VERBOSE=1 \
 && export MAKEFLAGS="-j1" \
 && bash pdi-deps/tools/build_scripts/build_and_run.sh



FROM main
