ARG VERSION
ARG COMPILER
ARG MPI
ARG LIBS
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-${MPI}${LIBS}-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

RUN spack -e pdienv gc -y

RUN spack clean -a

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

RUN echo "spack env load pdienv" > $SPACK_ROOT/etc/env/pdienv.env.sh
RUN if [[ -n "${LIBS}" ]]; then echo 'PDI_LIBS=provided; fi' >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "MPI_LIB=${MPI}" >> $SPACK_ROOT/etc/env/pdienv.env.sh
RUN echo "spack clean -a" >> $SPACK_ROOT/etc/env/pdienv.env.sh


FROM ghcr.io/pdidev/test_env/base:${IMAGE_TAG} AS main

COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}

SHELL ["docker-shell"]
ENTRYPOINT ["spack-env"]
CMD ["interactive-shell"]

RUN useradd -d /home/ci -m -U ci

ENV HOME=/home/ci
COPY --from=builder --chown ci:ci ${SPACK_HOME} ${HOME}/.spack
ENV SPACK_HOME=${HOME}/.spack

USER ci:ci
WORKDIR ${HOME}

ENV OMPI_MCA_rmaps_base_oversubscribe=1
ENV PDI_SYSTEM=docker-ubuntu-spack


FROM main AS test

#TODO: Integrate into main branch
RUN curl --output pdi-fix_398.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/fix_398/pdi-fix_398.tar.gz

RUN tar -xf pdi-fix_398.tar.gz

#TODO: cfgtest, python required https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/issues/399
RUN ln -s /usr/bin/python3 /usr/bin/python

#TODO: FTI unavailable in mixed clang/gfortran setup https://github.com/leobago/fti/issues/405
#          -DBUILD_FTI_PLUGIN=ON
#TODO: Doxygen badly detects iconv
#          remove -DICONV_IN_GLIBC=OFF
RUN USE_DEFAULT=SYSTEM \
 && BUILD_FTI_PLUGIN=OFF \
 && spack find flowvr &>/dev/null || USE_DEFAULT=EMBEDDED \
 && spack find llvm &>/dev/null || BUILD_FTI_PLUGIN=ON \
 && spack find --loaded \
 && cmake \
          -DDIST_PROFILE=Devel \
          -DBUILD_FTI_PLUGIN=${BUILD_FTI_PLUGIN} \
          -DICONV_IN_GLIBC=OFF \
          -DUSE_DEFAULT=${USE_DEFAULT} \
          -DUSE_Zpp=${USE_DEFAULT} \
          pdi-fix_398

RUN make VERBOSE=1

RUN ctest --output-on-failure


FROM main
