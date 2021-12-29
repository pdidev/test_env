ARG VERSION
ARG COMPILER
ARG MPI
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-${MPI}-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG COMPILER
ARG MPI
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

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


COPY ${VERSION}.lst optlibs.lst
#TODO: FTI unavailable in mixed clang/gfortran setup https://github.com/leobago/fti/issues/405
RUN if spack find llvm; then sed 's/.*\bfti\b.*//' -i optlibs.lst

RUN spack -e pdienv add -l optlibs $(cat optlibs.lst)
RUN spack -e pdienv concretize --reuse \
 || spack -e pdienv concretize --reuse -f

#TODO: Workaround FTI issue, python required for Fortran build
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN spack -e pdienv install ${SPACK_INSTALL_ARGS}
RUN rm /usr/bin/python

