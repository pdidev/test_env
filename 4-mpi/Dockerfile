ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS builder

ARG MPI
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--show-log-on-error --test=all --fail-fast"}
ENV MPI=${MPI}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN spack solve -I                      --reuse "${MPI} target=x86_64 cmake~ncurses~ownlibs^curl tls=openssl"\
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${MPI} target=x86_64 cmake~ncurses~ownlibs^curl tls=openssl"

RUN spack clean -a

RUN find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s || echo "Failed strip"
