ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG OPTLIBS_VERSION
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

ENV LIBS_ENV=${SPACK_ROOT}/var/spack/environments/optlibs

#TODO: Workaround FTI issue, fails to build, branch hotfix/fortran required
RUN git clone -b hotfix/fortran --depth 1 https://github.com/leobago/fti-spack ${SPACK_ROOT}/var/spack/repos/fti
RUN rm -rf ${SPACK_ROOT}/var/spack/repos/fti/.git
RUN spack repo add ${SPACK_ROOT}/var/spack/repos/fti

RUN git clone --depth 1 https://gitlab.jsc.fz-juelich.de/cstao-public/SIONlib/spack-repository.git ${SPACK_ROOT}/var/spack/repos/SIONlib
RUN rm -rf ${SPACK_ROOT}/var/spack/repos/SIONlib/.git
RUN spack repo add ${SPACK_ROOT}/var/spack/repos/SIONlib

RUN git clone --depth 1 https://github.com/pdidev/spack ${SPACK_ROOT}/var/spack/repos/pdi
RUN rm -rf ${SPACK_ROOT}/var/spack/repos/pdi/.git
RUN spack repo add ${SPACK_ROOT}/var/spack/repos/pdi

RUN mkdir -p ${LIBS_ENV}
COPY ${OPTLIBS_VERSION}.yaml ${LIBS_ENV}/spack.yaml
RUN sed -i -e "s/@COMPILER@/${COMPILER}/" -e "s/@MPI@/${MPI}/" ${LIBS_ENV}/spack.yaml

RUN spack env activate ${LIBS_ENV} \
 && spack config add "packages:all:target:[x86_64]" \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && spack concretize --reuse \
 && spack install ${SPACK_INSTALL_ARGS}
