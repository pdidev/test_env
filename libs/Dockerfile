ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG LIBS_VERSION
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV MPI=${MPI}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN git clone https://github.com/leobago/fti-spack /opt/spack-fti
RUN spack repo add /opt/spack-fti

RUN git clone https://gitlab.version.fz-juelich.de/SIONlib/spack-repository.git /opt/spack-SIONlib
RUN spack repo add /opt/spack-SIONlib

RUN git clone https://github.com/pdidev/spack /opt/spack-pdi
RUN spack repo add /opt/spack-pdi

RUN mkdir /opt/spack-environment
COPY ${LIBS_VERSION}.yaml /opt/spack-environment/
RUN set -ex \
 && mv /opt/spack-environment/${LIBS_VERSION}.yaml /opt/spack-environment/spack.yaml \
 && sed -i "s/@CMAKE@/${CMAKE}/" /opt/spack-environment/spack.yaml \
 && cat /opt/spack-environment/spack.yaml

RUN cd /opt/spack-environment \
 && spack env activate . \
 && spack config add config:install_tree:root:/opt/software \
 && spack config add config:view:/opt/view \
 && spack config add "packages:all:compiler:[${COMPILER}]"

RUN cd /opt/spack-environment \
 && spack env activate . \
 && spack concretize

RUN cd /opt/spack-environment \
 && spack env activate . \
 && spack solve --reuse \
 && spack install ${SPACK_INSTALL_ARGS} --reuse
