FROM pdidevel/xenial_libs_cmake3.5 AS builder

USER 0

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    curl \
    rsync

COPY --from=pdidevel/xenial_cmake3.10 /usr/local /tmp/xenial_cmake3.10

RUN rsync -r /tmp/xenial_cmake3.10/ /usr/local/

FROM pdidevel/xenial_libs_cmake3.5

USER 0

COPY --from=builder /usr/local /usr/local

RUN apt-get update -y \
 && apt-get purge -y \
    cmake \
 && apt-get autoremove \
 && apt-get upgrade -y \
 && apt-get install -y \
    python3-mpi4py \
    python3-numpy \
 && ldconfig

USER 1001
