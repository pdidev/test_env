ARG SPACK_IMAGE

ARG BASE_IMAGE

FROM ${SPACK_IMAGE} AS builder

ARG CMAKE

RUN spack mark -a -i

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && spack mark -e ${COMPSPEC}

RUN spack mark -e ${CMAKE} %${COMPILER}

RUN spack mark -e ${MPI} %${COMPILER} || true

RUN spack mark -e py-mpi4py

RUN [[ gcc != "${COMPILER}" ]] || COMPILER="gcc@7.6:" \
 && for N in $(grep '^\s*\(-\s\+\)\+[0-9a-zA-Z\^:~+@\.-]*\s*$' ${LIBS_ENV}/spack.yaml | grep -v '\bmatrix\b' | sed 's/\s*\(-\s*\)*//') \
  ; do \
      spack mark -e $N %${COMPILER} || true \
  ; done

RUN spack compiler find

RUN spack gc -y

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && spack load ${COMPSPEC} \
 && echo "spack load ${COMPSPEC}" > ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN spack load ${CMAKE} %${COMPILER} \
 && echo "spack load ${CMAKE} %${COMPILER}" >> ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN spack load ${MPI} %${COMPILER} \
 && echo "spack load ${MPI} %${COMPILER}" >> ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN spack load py-mpi4py \
 && echo "spack load py-mpi4py" >> ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN [[ gcc != "${COMPILER}" ]] || COMPILER="gcc@7.6:" \
 && for N in $(grep '^\s*\(-\s\+\)\+[0-9a-zA-Z\^:~+@\.-]*\s*$' ${LIBS_ENV}/spack.yaml | grep -v '\bmatrix\b' | sed 's/\s*\(-\s*\)*//') \
  ; do \
      spack load $N %${COMPILER} \
      && echo "spack load $N %${COMPILER}" >> ${SPACK_ROOT}/share/spack/pdi-env.sh \
      || true \
  ; done

RUN spack activate py-mpi4py \
 && echo "spack activate py-mpi4py" >> ${SPACK_ROOT}/share/spack/pdi-activate.sh \
 || true

RUN for N in $(grep '^\s*\(-\s\+\)\+py-[0-9a-zA-Z\^:~+@\.-]*\s*$' ${LIBS_ENV}/spack.yaml | grep -v '\bmatrix\b' | sed 's/\s*\(-\s*\)*//') \
  ; do \
      spack activate $N \
   && echo "spack activate $N" >> ${SPACK_ROOT}/share/spack/pdi-activate.sh \
   || true \
  ; done

RUN spack clean -a \
 && echo "spack clean -a" >> ${SPACK_ROOT}/share/spack/pdi-env.sh \
 && echo "spack clean -a" >> ${SPACK_ROOT}/share/spack/pdi-activate.sh

RUN if spack find flowvr &> /dev/null; then echo 'export PDI_LIBS=provided' >> ${SPACK_ROOT}/share/spack/pdi-env.sh; fi || true
RUN if spack find mpich &> /dev/null; then echo 'export MPI_LIB=mpich' >> ${SPACK_ROOT}/share/spack/pdi-env.sh; fi || true
RUN if spack find openmpi &> /dev/null; then echo 'export MPI_LIB=openmpi' >> ${SPACK_ROOT}/share/spack/pdi-env.sh; fi || true

RUN sed -i \
    's%unset _sp_initializing%. ${SPACK_ROOT}/share/spack/pdi-env.sh; unset _sp_initializing%' \
    ${SPACK_ROOT}/share/spack/setup-env.sh

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s


FROM ${BASE_IMAGE} AS main

COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}

SHELL ["docker-shell"]
ENTRYPOINT ["spack-env"]
CMD ["interactive-shell"]

COPY --from=builder ${SPACK_HOME} ${SPACK_HOME}
RUN . ${SPACK_ROOT}/share/spack/pdi-activate.sh

ENV HOME=/home/ci
RUN useradd -d ${HOME} -m -U ci
COPY --from=builder --chown=ci:ci ${SPACK_HOME} ${HOME}/.spack
RUN chown -R ci:ci ${HOME}
ENV SPACK_HOME=${HOME}/.spack
USER ci:ci
WORKDIR ${HOME}

ENV OMPI_MCA_rmaps_base_oversubscribe=1
ENV PDI_SYSTEM=docker-ubuntu-spack


FROM main AS test

#TODO: Integrate into main branch
RUN curl --output pdi-fix_398.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/fix_398/pdi-fix_398.tar.gz

RUN tar -xf pdi-fix_398.tar.gz

#TODO: Workaround cfgtest, python required https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/issues/399
USER 0
RUN ln -s /usr/bin/python3 /usr/bin/python
USER ci:ci

#TODO: NetCDF fails to build because it doesn't find zlib
#          remove -DBUILD_DECL_NETCDF_PLUGIN / ${NO_EMBEDDED}
#TODO: FlowVR examples fails to build due to missing include dir for GL/glu.h
#          remove -DBUILD_FLOWVR_PLUGIN / OFF
#TODO: FlowVR fails to build due to missing include dir for GL/glu.h
#          remove -DBUILD_FLOWVR_PLUGIN / ${NO_EMBEDDED}
#TODO: FTI does not correctly add zlib include path where required when building
#          remove -DBUILD_FTI_PLUGIN / ${NO_EMBEDDED}
#TODO: Doxygen badly detects iconv
#          remove -DICONV_IN_GLIBC / OFF
#TODO: system googletest fails to compile with recent clang due to https://github.com/google/googletest/issues/3427
#          switch to forced embedded googletest upstream
RUN USE_DEFAULT=SYSTEM \
 && NO_EMBEDDED=ON \
 && spack find flowvr || USE_DEFAULT=EMBEDDED \
 && spack find flowvr || NO_EMBEDDED=OFF \
 && spack find --loaded \
 && cmake \
          -DDIST_PROFILE=Devel \
          -DBUILD_DECL_NETCDF_PLUGIN=${NO_EMBEDDED} \
          -DBUILD_FLOWVR_PLUGIN=OFF \
          -DBUILD_FTI_PLUGIN=${NO_EMBEDDED} \
          -DICONV_IN_GLIBC=OFF \
          -DUSE_DEFAULT=${USE_DEFAULT} \
          -DUSE_Zpp=${USE_DEFAULT} \
          -DUSE_GTest=EMBEDDED \
          pdi-fix_398

RUN make VERBOSE=1

#TODO: PDI_example_decl_netcdf_C fails with NetCDF 4.3.3 https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/issues/383
#TODO: Many examples fail with clang 8 https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/issues/403
RUN if spack find 'netcdf-c@4.3.3'; then CTEST_ARGS="-E PDI_example_decl_netcdf_C"; fi \
 && spack find 'llvm@8.0.0' || ctest ${CTEST_ARGS} --output-on-failure


FROM main
