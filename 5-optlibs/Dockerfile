ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS builder

ARG OPTLIBS_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --test=all --fail-fast"}
ENV OPTLIBS_VERSION=${OPTLIBS_VERSION}

RUN git clone --depth 1 https://github.com/leobago/fti-spack ${SPACK_ROOT}/var/spack/repos/fti
RUN rm -rf ${SPACK_ROOT}/var/spack/repos/fti/.git
RUN spack repo add ${SPACK_ROOT}/var/spack/repos/fti

RUN git clone --depth 1 https://gitlab.version.fz-juelich.de/SIONlib/spack-repository.git ${SPACK_ROOT}/var/spack/repos/SIONlib
RUN rm -rf ${SPACK_ROOT}/var/spack/repos/SIONlib/.git
RUN spack repo add ${SPACK_ROOT}/var/spack/repos/SIONlib

RUN git clone --depth 1 https://github.com/pdidev/spack ${SPACK_ROOT}/var/spack/repos/pdi
RUN rm -rf ${SPACK_ROOT}/var/spack/repos/pdi/.git
RUN spack repo add ${SPACK_ROOT}/var/spack/repos/pdi

RUN mkdir ${SPACK_ROOT}/var/environments/optlibs
COPY ${OPTLIBS_VERSION}.yaml ${SPACK_ROOT}/var/environments/optlibs/spack.yaml
RUN sed -i -e "s/@COMPILER@/${COMPILER}/" -e "s/@MPI@/${MPI}/" ${SPACK_ROOT}/var/environments/optlibs/spack.yaml

RUN spack env activate ${SPACK_ROOT}/var/environments/optlibs \
 && spack config add "packages:all:target:[x86_64]" \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && spack concretize --test=all --reuse \
 && spack install ${SPACK_INSTALL_ARGS} --reuse

RUN spack clean -a

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s || echo "Failed strip"


FROM ${BASE_IMAGE}

COPY --from=builder ${SPACK_HOME} ${SPACK_HOME}
COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}
