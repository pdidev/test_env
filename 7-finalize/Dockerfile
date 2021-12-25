ARG SPACK_IMAGE

ARG BASE_IMAGE

FROM ${SPACK_IMAGE} AS builder

ARG CMAKE

RUN spack mark -a -i

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && spack mark -e ${COMPSPEC}

RUN spack mark -e ${CMAKE} %${COMPILER}

RUN spack mark -e ${MPI} %${COMPILER} || true

RUN for N in $(grep '^\s*\(-\s\+\)\+[0-9a-zA-Z\^:~+@\.-]*\s*$' ${LIBS_ENV}/spack.yaml | grep -v '\bmatrix\b' | sed 's/\s*\(-\s*\)*//') \
  ; do \
      spack mark -e $N %${COMPILER} || true \
  ; done

RUN spack compiler find

RUN spack gc -y

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && echo "spack load ${COMPSPEC}" > ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN echo "spack load ${CMAKE} %${COMPILER}" >> ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN echo "spack load ${MPI} %${COMPILER}" >> ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN for N in $(grep '^\s*\(-\s\+\)\+[0-9a-zA-Z\^:~+@\.-]*\s*$' ${LIBS_ENV}/spack.yaml | grep -v '\bmatrix\b' | sed 's/\s*\(-\s*\)*//') \
  ; do \
      spack load $N %${COMPILER} \
      && echo "spack load $N %${COMPILER}" >> ${SPACK_ROOT}/share/spack/pdi-env.sh \
      || true \
  ; done

RUN for N in $(grep '^\s*\(-\s\+\)\+py-[0-9a-zA-Z\^:~+@\.-]*\s*$' ${LIBS_ENV}/spack.yaml | grep -v '\bmatrix\b' | sed 's/\s*\(-\s*\)*//') \
  ; do \
      spack activate $N  \
      && echo "spack activate $N" >> ${SPACK_ROOT}/share/spack/pdi-env.sh \
      || true \
  ; done

RUN spack clean -a \
 && echo "spack clean -a" >> ${SPACK_ROOT}/share/spack/pdi-env.sh

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

RUN useradd -d /home/ci -m -U ci

ENV HOME=/home/ci
COPY --from=builder ${SPACK_HOME} ${HOME}/.spack
ENV SPACK_HOME=${HOME}/.spack
RUN chown -R ci:ci ${HOME}

#TODO: Workaround cfgtest, python required
RUN ln -s /usr/bin/python3 /usr/bin/python

USER ci:ci
WORKDIR ${HOME}

ENV OMPI_MCA_rmaps_base_oversubscribe=1


FROM main AS test

RUN curl --output pdi-fix_398.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/fix_398/pdi-fix_398.tar.gz

RUN tar -xf pdi-fix_398.tar.gz

#TODO: fails with recent clang due to https://github.com/google/googletest/issues/3427
#          -DUSE_GTest=${USE_DEFAULT}
#TODO: FTI embedded build fails due to missing dependency on zlib
#          -DBUILD_FTI_PLUGIN=ON
#TODO: FTI unavailable in mixed clang/gfortran setup
#          -DBUILD_FTI_PLUGIN=ON
#TODO: FlowVR fails to build due to missing include dir for GL/glu.h
#          -DBUILD_FLOWVR_PLUGIN=ON
#TODO: Doxygen badly detects iconv
#          remove -DICONV_IN_GLIBC=OFF
#TODO: Netcdf fails to detect zlib
#          -DBUILD_DECL_NETCDF_PLUGIN=ON
RUN USE_DEFAULT=SYSTEM \
 && NO_EMBEDDED=ON \
 && BUILD_FTI_PLUGIN=OFF \
 && spack find flowvr || USE_DEFAULT=EMBEDDED \
 && spack find flowvr || NO_EMBEDDED=OFF \
 && spack find llvm || BUILD_FTI_PLUGIN=${NO_EMBEDDED} \
 && spack find --loaded \
 && cmake \
          -DDIST_PROFILE=Devel \
          -DBUILD_CFG_VALIDATOR=${NO_EMBEDDED} \
          -DBUILD_DECL_NETCDF_PLUGIN=${NO_EMBEDDED} \
          -DBUILD_FLOWVR_PLUGIN=OFF \
          -DBUILD_FTI_PLUGIN=${BUILD_FTI_PLUGIN} \
          -DICONV_IN_GLIBC=OFF \
          -DUSE_DEFAULT=${USE_DEFAULT} \
          -DUSE_Zpp=${USE_DEFAULT} \
          -DUSE_GTest=EMBEDDED \
          pdi-fix_398

RUN make VERBOSE=1

RUN ctest --output-on-failure


FROM main
