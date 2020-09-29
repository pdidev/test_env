FROM pdidevel/centos_base AS builder

USER 0

RUN curl -Lso cmake.tar.gz https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz \
 && tar -xzf cmake.tar.gz \
 && rm cmake.tar.gz \
 && cd cmake* \
 && ./configure \
 && make -j \
 && make install \
 && cd \
 && rm -r cmake*

FROM pdidevel/centos_cmake3.10

USER 0

COPY --from=builder /usr/local /usr/local

USER 1001
