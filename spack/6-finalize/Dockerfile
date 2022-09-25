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
 && spack -e pdienv mark -ea \
 && spack gc -y

RUN spack -e pdienv config --scope env:pdienv add modules:prefix_inspections:lib64:[LD_LIBRARY_PATH]
RUN spack -e pdienv config --scope env:pdienv add modules:prefix_inspections:lib:[LD_LIBRARY_PATH]

RUN find -L ${SPACK_ROOT}/opt/spack -name 'intel-mkl-*' -prune -o -type f -exec file -i '{}' '+' \
  | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

RUN touch $SPACK_ROOT/etc/env/pdienv.env.sh

RUN echo "export PDI_SYSTEM=spack" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "export PDI_DEPS=${VERSION}" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "export PDI_COMPILER=${COMPILER}" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "export PDI_MPI=${MPI}" >> $SPACK_ROOT/etc/env/pdienv.env.sh

RUN if [[ openmpi = "${MPI}" ]] \
  ; then echo 'export OMPI_MCA_rmaps_base_oversubscribe=1' >> $SPACK_ROOT/etc/env/pdienv.env.sh \
  ; fi
RUN if [[ -n "${LIBS}" ]] \
  ; then echo 'export PDI_LIBS=provided' >> $SPACK_ROOT/etc/env/pdienv.env.sh \
  ; fi

RUN echo "spack load $(cat compiler.lst)" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "spack env activate pdienv" >> $SPACK_ROOT/etc/env/pdienv.env.sh

RUN spack clean -a


FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG} AS main

COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}

RUN useradd -d /home/ci -m -U ci \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/docker-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/interactive-shell \
 && ln -s ${SPACK_ROOT}/share/spack/docker/entrypoint.bash /usr/local/bin/spack-env
ENV HOME=/home/ci

USER ci:ci
WORKDIR ${HOME}

SHELL ["docker-shell"]
ENTRYPOINT ["spack-env"]
CMD ["bash", "-i"]


FROM main AS test

RUN curl  --output pdi-master.tar.bz2 https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/master/pdi-master.tar.bz2
RUN tar -xf pdi-master.tar.bz2

RUN export MAKEFLAGS="-j 1" \
 && bash pdi-master/tools/build_scripts/build_and_run.sh


FROM main
