ARG VERSION
ARG IMAGE_TAG

FROM ghcr.io/pdidev/test_env/spackbase:${IMAGE_TAG}

LABEL "org.opencontainers.image.source"="https://github.com/pdidev/test_env"


ARG VERSION

COPY ${VERSION}.branch spack.branch
RUN mkdir -p ${SPACK_ROOT} \
 && git clone --depth 1 -b $(cat spack.branch) ${SPACK_ROOT} \
 && rm -rf ${SPACK_ROOT}/.git


SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]


RUN spack compiler find --scope site
RUN spack config --scope site add 'packages:all:target:[x86_64]'
RUN spack config --scope site add "config:install_tree:root:${SPACK_INSTALL}"
RUN spack config --scope site add 'modules:prefix_inspections:lib64:[LD_LIBRARY_PATH]'
RUN spack config --scope site add 'modules:prefix_inspections:lib:[LD_LIBRARY_PATH]'
RUN spack config --scope site add "modules:default:roots:tcl:${SPACK_MODULES}"


ARG COMPILER
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

COPY ${COMPILER}.lst compilerpkg.lst
RUN spack solve -I --reuse $(cat compilerpkg.lst) target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse --only dependencies $(cat compilerpkg.lst) target=x86_64 \
 && spack clean -a
