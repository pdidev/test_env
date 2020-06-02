FROM pdidevel/xenial_cmake3.5 AS builder

USER 0

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    curl

RUN curl -Lso doxygen.tar.gz https://sourceforge.net/projects/doxygen/files/rel-1.8.13/doxygen-1.8.13.src.tar.gz \
 && tar -xf doxygen.tar.gz \
 && cd doxygen* \
 && cmake . \
 && make -j \
 && make install

RUN curl -Lso flowvr.tar.gz https://gitlab.inria.fr/flowvr/flowvr-ex/-/archive/master/flowvr-ex-master.tar.gz \
 && tar -xf flowvr.tar.gz \
 && cd flowvr* \
 && cmake -DOpenGL_GL_PREFERENCE=LEGACY . \
 && make -j \
 && make install

RUN curl -Lso fti.tar.gz https://github.com/leobago/fti/archive/master.tar.gz \
 && tar -xf fti.tar.gz \
 && cd fti* \
 && cmake -DENABLE_EXAMPLES=OFF -DENABLE_TESTS=OFF -DENABLE_DOCU=OFF . \
 && make -j \
 && make install

FROM pdidevel/xenial_cmake3.5

USER 0

COPY --from=builder /usr/local /usr/local

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    astyle \
    libparaconf-dev \
    libspdlog-dev \
    pybind11-dev \
    zpp \
 && ldconfig \
 && echo '. /usr/local/bin/flowvr-suite-config.sh' > /etc/profile.d/zzz_enable_flowvr.sh

USER 1001
