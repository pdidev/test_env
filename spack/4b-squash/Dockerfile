ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-4a-${IMAGE_TAG} AS builder



FROM ghcr.io/pdidev/test_env/spackbase:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


COPY --from=builder ${HOME} ${HOME}
COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}
COPY --from=builder ${SPACK_INSTALL} ${SPACK_INSTALL}


# use system gfortran for clang that doesn't support fortran
RUN set -ex \
 && export DEBIAN_FRONTEND=noninteractive \
  ; if grep -q clang compiler.lst \
  ; then \
         apt-get update -y \
      && apt-get upgrade -y \
      && apt-get install -y --no-install-recommends \
                 gfortran-10 \
      && apt-get autoremove -y \
      && apt-get clean -y \
      && apt-get autoclean -y \
      && rm -rf /var/lib/apt/lists/*  \
  ; fi


SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]
