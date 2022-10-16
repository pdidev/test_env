ARG VERSION
ARG COMPILER
ARG MPI
ARG LIBS
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-${MPI}${LIBS}-${IMAGE_TAG} as builder

ARG VERSION
ARG COMPILER
ARG MPI
ARG LIBS

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

RUN spack mark -ia \
 && for N in $(spack -e pdienv find --format '{name}' --no-groups -L | awk '{print $1}') \
  ; do spack mark -e "/$N" \
  ; done \
 && spack gc -y

RUN find -L ${SPACK_INSTALL} -type f -exec file -i '{}' '+' \
  | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

RUN spack -e pdienv module tcl refresh --delete-tree -y
RUN spack -e pdienv env loads

RUN touch /etc/pdienv.env.sh
RUN echo "export PDI_SYSTEM=spack" >> /etc/pdienv.env.sh
RUN echo "export PDI_DEPS=${VERSION}" >> /etc/pdienv.env.sh
RUN echo "export PDI_COMPILER=${COMPILER}" >> /etc/pdienv.env.sh
RUN echo "export PDI_MPI=${MPI}" >> /etc/pdienv.env.sh
RUN if [[ openmpi = "${MPI}" ]] \
  ; then echo 'export OMPI_MCA_rmaps_base_oversubscribe=1' >> /etc/pdienv.env.sh \
  ; fi
RUN if [[ -n "${LIBS}" ]] \
  ; then echo 'export PDI_LIBS=provided' >> /etc/pdienv.env.sh \
  ; fi
RUN echo "MODULEPATH=${MODULEPATH}" >> /etc/pdienv.env.sh

RUN spack clean -a


FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG} AS main

RUN mkdir -p ${SPACK_ROOT}/var/spack/environments \
 && useradd -d /home/ci -m -U ci

COPY --from=builder ${SPACK_INSTALL} ${SPACK_INSTALL}
COPY --from=builder ${SPACK_MODULES} ${SPACK_MODULES}
COPY --from=builder ${SPACK_ROOT}/var/spack/environments/pdienv/loads /etc/pdienv.modules.sh
COPY --from=builder /etc/pdienv.env.sh /etc/pdienv.env.sh
COPY bash_run /bin/

RUN set -ex \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            environment-modules \
            gfortran \
            git \
            libstdc++-7-dev \
            locales \
            make \
            tcl \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y

USER ci:ci
WORKDIR /home/ci
ENV HOME /home/ci

ENTRYPOINT ["/bin/bash_run"]
SHELL ["/bin/bash_run", "bash", "-c"]
CMD ["bash", "-i"]


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

RUN curl --output pdi-master.tar.bz2 https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/master/pdi-master.tar.bz2
RUN tar -xf pdi-master.tar.bz2

RUN export MAKEFLAGS="-j 1" \
 && bash pdi-master/tools/build_scripts/build_and_run.sh

FROM main
