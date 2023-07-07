ARG VERSION
ARG COMPILER
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/spackbase:${VERSION}-${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"

COPY --from=ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-3b-${IMAGE_TAG} ${HOME} ${HOME}
COPY --from=ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-3b-${IMAGE_TAG} ${SPACK_ROOT} ${SPACK_ROOT}
COPY --from=ghcr.io/pdidev/test_env/builder:${VERSION}-${COMPILER}-3b-${IMAGE_TAG} ${SPACK_INSTALL} ${SPACK_INSTALL}

SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]
