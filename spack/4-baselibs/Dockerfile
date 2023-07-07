ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-3c-${IMAGE_TAG} as builder

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

ARG VERSION
ARG COMPILER
ARG IMAGE_TAG
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"


# --deprecated for some versions of our old env (python 3.6)
RUN spack -e pdienv concretize -fU
RUN spack -e pdienv fetch --deprecated \
 || spack -e pdienv fetch --deprecated \
 || spack -e pdienv fetch --deprecated \
 || spack -e pdienv fetch --deprecated
RUN spack -e pdienv install --deprecated ${SPACK_INSTALL_ARGS}
RUN spack clean -a



FROM ghcr.io/pdidev/test_env/spackbase:${VERSION}-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

COPY --from=builder ${HOME} ${HOME}
COPY --from=builder ${SPACK_ROOT} ${SPACK_ROOT}
COPY --from=builder ${SPACK_INSTALL} ${SPACK_INSTALL}

SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]
