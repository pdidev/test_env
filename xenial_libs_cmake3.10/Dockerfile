FROM pdidevel/xenial_libs_cmake3.5

USER 0

COPY --from=pdidevel/xenial_cmake3.10 /usr/local /usr/local

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    python3-mpi4py \
 && ldconfig

USER 1001
