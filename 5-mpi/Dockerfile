ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG MPI
ARG SPACK_INSTALL_ARGS="--show-log-on-error --fail-fast"

ENV MPI=${MPI}
 
SHELL ["docker-shell"]
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["interactive-shell"]

RUN spack solve   -I --reuse \
                  "${MPI}%${COMPILER}^cmake~ownlibs^curl" tls=openssl target=x86_64 \
 && spack install ${SPACK_INSTALL_ARGS} --reuse \
                  "${MPI}%${COMPILER}^cmake~ownlibs^curl" tls=openssl target=x86_64
