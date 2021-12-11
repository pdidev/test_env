ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG OPTLIBS_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV OPTLIBS_VERSION=${OPTLIBS_VERSION}

RUN git clone --depth 1 https://github.com/leobago/fti-spack ${SPACK_ROOT}/var/spack/repos/fti \
 && git clone --depth 1 https://gitlab.version.fz-juelich.de/SIONlib/spack-repository.git ${SPACK_ROOT}/var/spack/repos/SIONlib \
 && git clone --depth 1 https://github.com/pdidev/spack ${SPACK_ROOT}/var/spack/repos/pdi \
 && rm -rf ${SPACK_ROOT}/var/spack/repos/*/.git \
 && spack repo add ${SPACK_ROOT}/var/spack/repos/fti \
 && spack repo add ${SPACK_ROOT}/var/spack/repos/SIONlib \
 && spack repo add ${SPACK_ROOT}/var/spack/repos/pdi \
 && find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/x-executable; charset=binary/ {print $1}' \
  | xargs strip -s

RUN mkdir /opt/optlibs-env
COPY ${OPTLIBS_VERSION}.yaml /opt/optlibs-env/spack.yaml
RUN sed -i -e "s/@COMPILER@/${COMPILER}/" -e "s/@MPI@/${MPI}/" /opt/optlibs-env/spack.yaml \
 && spack env activate /opt/optlibs-env \
 && spack config add "packages:all:target:[x86_64]" \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && spack concretize --test=all --reuse \
 && spack install ${SPACK_INSTALL_ARGS} \
 && find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s || true
