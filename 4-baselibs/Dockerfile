ARG BASE_IMAGE

FROM ${BASE_IMAGE}


ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

ENV LIBS_ENV=${SPACK_ROOT}/var/spack/environments/baselibs

RUN spack solve -I                      --reuse "cmake~ownlibs^curl" tls=openssl target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "cmake~ownlibs^curl" tls=openssl target=x86_64

RUN spack solve -I                      --reuse "cmake@3.10.0~ownlibs^curl" tls=openssl target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "cmake@3.10.0~ownlibs^curl" tls=openssl target=x86_64

RUN mkdir -p ${LIBS_ENV}
COPY baselibs.yaml ${LIBS_ENV}/spack.yaml
RUN sed -i -e "s/@COMPILER@/${COMPILER}/" -e "s/@COMPSPEC@/${COMPILER/clang/llvm}/" ${LIBS_ENV}/spack.yaml

RUN spack env activate ${LIBS_ENV} \
 && spack config add "packages:all:target:[x86_64]" \
 && spack config add "packages:all:compiler:[${COMPILER}]" \
 && spack concretize --reuse \
 && spack install ${SPACK_INSTALL_ARGS}
