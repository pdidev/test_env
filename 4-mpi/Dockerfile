ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG MPI
ARG SPACK_INSTALL_ARGS

ENV SPACK_INSTALL_ARGS=${SPACK_INSTALL_ARGS:-"--verbose --test=all --fail-fast"}
ENV MPI=${MPI}

SHELL ["/usr/local/bin/spack-env", "/bin/bash", "-c"]

RUN set -ex \
 && spack solve                         --reuse "${MPI}" target=x86_64 "%${COMPILER}" "^cmake~ncurses~ownlibs" \
 && spack install ${SPACK_INSTALL_ARGS} --reuse "${MPI}" target=x86_64 "%${COMPILER}" "^cmake~ncurses~ownlibs" \
 && find -L ${SPACK_ROOT}/opt/spack -type f -exec readlink -f '{}' \; \
  | xargs file -i | awk -F: '/(x-executable|x-archive|x-sharedlib); charset=binary/ {print $1}' \
  | xargs -r strip -s || true
