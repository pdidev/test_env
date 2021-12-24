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

RUN spack clean -a 

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

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

RUN sed -i \
    's%unset _sp_initializing%. ${SPACK_ROOT}/share/spack/pdi-env.sh; unset _sp_initializing%' \
    ${SPACK_ROOT}/share/spack/setup-env.sh


FROM ${BASE_IMAGE} AS main

COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}

RUN . ${SPACK_ROOT}/share/spack/pdi-env.sh \
 && useradd -d /home/ci -m -U ci

ENV HOME=/home/ci
COPY --from=builder ${SPACK_HOME} ${HOME}/.spack
ENV SPACK_HOME=${HOME}/.spack
RUN chown -R ci:ci ${HOME}

USER ci:ci
WORKDIR ${HOME}
SHELL ["docker-shell"]
ENTRYPOINT ["spack-env"]
CMD ["interactive-shell"]

ENV OMPI_MCA_rmaps_base_oversubscribe=1


FROM main AS test

RUN curl --output pdi-fix_398.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/fix_398/pdi-fix_398.tar.gz

RUN tar -xf pdi-fix_398.tar.gz

#TODO: fails with recent clang due to https://github.com/google/googletest/issues/3427
#          -DUSE_GTest=${USE_DEFAULT}
#TODO: FTI embedded build fails du to missing dependency on zlib
#          -DBUILD_FTI_PLUGIN=OFF
#TODO: FlowVR fails to build due to missing include dir for GL/glu.h
#          -DBUILD_FLOWVR_PLUGIN=OFF
#TODO: Doxygen badly detects iconv
#          -DICONV_IN_GLIBC=OFF
RUN USE_DEFAULT=SYSTEM \
 && spack find flowvr || USE_DEFAULT=EMBEDDED \
 && spack find --loaded \
 && cmake \
          -DDIST_PROFILE=Devel \
          -DBUILD_CFG_VALIDATOR=OFF \
          -DBUILD_FLOWVR_PLUGIN=OFF \
          -DBUILD_FTI_PLUGIN=OFF \
          -DUSE_DEFAULT=${USE_DEFAULT} \
          -DUSE_Zpp=${USE_DEFAULT} \
          -DUSE_GTest=EMBEDDED \
          -DICONV_IN_GLIBC=OFF \
          pdi-fix_398

RUN make VERBOSE=1

RUN ctest --output-on-failure


FROM main
