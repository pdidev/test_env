FROM pdidevel/xenial_libs_cmake3.5 AS builder

USER 0

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    curl

RUN curl -Lso cmake.tar.gz https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz \
 && tar -xf cmake.tar.gz \
 && cd cmake* \
 && cmake . \
 && make -j 4 \
 && make install

FROM pdidevel/xenial_libs_cmake3.5

USER 0

COPY --from=builder /usr/local /usr/local

RUN apt-get update -y \
 && apt-get purge -y \
    cmake \
 && apt-get autoremove -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    python3-mpi4py \
    python3-numpy \
 && ldconfig

USER 1001
