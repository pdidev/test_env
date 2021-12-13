ARG SPACK_IMAGE

FROM ${SPACK_IMAGE} AS builder

RUN spack mark -a -i
RUN spack mark -e ${CMAKE} %${COMPILER} target=x86_64
RUN spack env activate ${LIBS_ENV} \
 && spack gc -y

RUN spack clean -a 

RUN >> ${SPACK_ROOT}/share/spack/setup-env.sh

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s

ARG BASE_IMAGE

FROM ${BASE_IMAGE}

COPY --from=builder ${SPACK_HOME} ${SPACK_HOME}
COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}

SHELL ["docker-shell"]
ENTRYPOINT ["spack-env"]
CMD ["interactive-shell"]
