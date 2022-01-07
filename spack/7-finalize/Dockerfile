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

RUN spack mark -e $(cat cmake.lst)
RUN spack mark -e $(sed 's/clang/llvm/' compiler.lst)
RUN spack compiler find
RUN spack gc -y

RUN find -L ${SPACK_ROOT}/opt/spack -name 'intel-mkl-*' -prune -o -type f -exec file -i '{}' '+' \
  | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

RUN touch $SPACK_ROOT/etc/env/pdienv.env.sh

RUN echo "export PDI_SYSTEM=spack" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "export PDI_DEPS=${VERSION}" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "export PDI_COMPILER=${COMPILER}" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "export MPI_LIB=${MPI}" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "export PDI_MPI=${MPI}" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN if [[ openmpi = "${MPI}" ]] \
  ; then echo 'export OMPI_MCA_rmaps_base_oversubscribe=1' >> $SPACK_ROOT/etc/env/pdienv.env.sh \
  ; fi
RUN if [[ -n "${LIBS}" ]] \
  ; then echo 'export PDI_LIBS=provided' >> $SPACK_ROOT/etc/env/pdienv.env.sh \
  ; fi

RUN echo "spack load $(cat cmake.lst)" >> $SPACK_ROOT/etc/env/pdienv.env.sh \
 && echo "spack load $(sed 's/clang/llvm/' compiler.lst)" >> $SPACK_ROOT/etc/env/pdienv.env.sh \
 && echo "spack env activate pdienv" >> $SPACK_ROOT/etc/env/pdienv.env.sh \
 && spack clean -a


FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG} AS main

COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}

RUN useradd -d /home/ci -m -U ci
ENV HOME=/home/ci

COPY --from=builder --chown=ci:ci ${SPACK_HOME} ${HOME}/.spack
ENV SPACK_HOME=${HOME}/.spack

USER ci:ci
WORKDIR ${HOME}

SHELL ["docker-shell"]
ENTRYPOINT ["spack-env"]
CMD ["bash", "-i"]


FROM main AS test

#TODO: Integrate into main branch
RUN curl  --output pdi-fix_398.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/fix_398/pdi-fix_398.tar.gz
RUN tar -xf pdi-fix_398.tar.gz

RUN export MAKEFLAGS="-j 1" \
 && bash pdi-fix_398/tools/build_scripts/build_and_run.sh


FROM main
