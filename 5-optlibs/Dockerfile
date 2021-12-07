ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG OPTLIBS_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV OPTLIBS_VERSION=${OPTLIBS_VERSION}

RUN git clone https://github.com/leobago/fti-spack /opt/spack-fti
RUN git clone https://gitlab.version.fz-juelich.de/SIONlib/spack-repository.git /opt/spack-SIONlib
RUN git clone https://github.com/pdidev/spack /opt/spack-pdi
RUN spack repo add /opt/spack-fti \
 && spack repo add /opt/spack-SIONlib \
 && spack repo add /opt/spack-pdi

RUN mkdir /opt/optlibs-env
COPY ${OPTLIBS_VERSION}.yaml /opt/optlibs-env/spack.yaml
RUN sed -i -e "s/@COMPILER@/${COMPILER}/" -e "s/@MPI@/${MPI}/" /opt/optlibs-env/spack.yaml \
 && spack env activate /opt/optlibs-env \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && spack concretize --test=all --reuse \
 && spack install ${SPACK_INSTALL_ARGS}
