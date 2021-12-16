ARG SPACK_IMAGE

ARG BASE_IMAGE

FROM ${SPACK_IMAGE} AS builder

ARG CMAKE

RUN spack mark -a -i

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && COMPSPEC=${COMPSPEC} $([[ ! ${COMPILER} =~ ^gcc ]] || echo -n "~bootstrap") \
 && spack mark -e ${COMPSPEC}

RUN spack mark -e ${CMAKE} %${COMPILER}

RUN for N in $(grep '^\s*\(-\s\+\)\+[0-9a-zA-Z~@\.-]*\s*$' ${LIBS_ENV}/spack.yaml | sed 's/\s*\(-\s*\)*//') \
  ; do \
      spack mark --all -e $N %${COMPILER} || true \
  ; done

RUN spack compiler find

RUN spack gc -y

RUN spack clean -a 

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

RUN COMPSPEC=${COMPILER/clang/llvm} \
 && COMPSPEC=${COMPSPEC} $([[ ! ${COMPILER} =~ ^gcc ]] || echo -n "~bootstrap") \
 && echo "spack load ${COMPSPEC}" > ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN echo "spack load ${CMAKE} %${COMPILER}" >> ${SPACK_ROOT}/share/spack/pdi-env.sh

RUN for N in $(grep '^\s*\(-\s\+\)\+[0-9a-zA-Z~@\.-]*\s*$' ${LIBS_ENV}/spack.yaml | sed 's/\s*\(-\s*\)*//') \
  ; do \
      spack load $N %${COMPILER} \
      && echo "spack load $N %${COMPILER}" >> ${SPACK_ROOT}/share/spack/pdi-env.sh \
      || true \
  ; done

RUN sed -i \
    's%unset _sp_initializing%. ${SPACK_ROOT}/share/spack/pdi-env.sh; unset _sp_initializing%' \
    ${SPACK_ROOT}/share/spack/setup-env.sh


FROM ${BASE_IMAGE} AS main

COPY --from=builder ${SPACK_HOME} ${SPACK_HOME}
COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}

SHELL ["docker-shell"]
ENTRYPOINT ["spack-env"]
CMD ["interactive-shell"]

FROM main AS test

RUN curl --output pdi-fix_398.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/fix_398/pdi-fix_398.tar.gz

RUN tar -xf pdi-fix_398.tar.gz

RUN cmake -DDIST_PROFILE=Devel -DBUILD_DOCUMENTATION=OFF -DBUILD_FLOWVR_PLUGIN=OFF -DBUILD_FTI_PLUGIN=OFF pdi-fix_398

RUN make -j

RUN ctest --output-on-failure

FROM main

