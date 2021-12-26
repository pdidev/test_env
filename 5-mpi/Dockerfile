ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG MPI
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

ENV MPI=${MPI}

RUN spack env activate ${LIBS_ENV} \
 && spack add "${MPI} ~internal-hwloc ^cmake~ownlibs ^curl tls=openssl" \
 && spack add py-mpi4py \
 && spack concretize --reuse \
 && spack install ${SPACK_INSTALL_ARGS}
