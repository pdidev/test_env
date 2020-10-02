FROM pdidevel/xenial_cmake3.5 AS builder

USER 0

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    astyle \
    libhdf5-mpich-dev \
    libparaconf-dev \
    libspdlog-dev \
    pybind11-dev \
    zpp \
 && apt-get clean \
 && apt-get autoclean

RUN curl -Lso doxygen.tar.gz https://sourceforge.net/projects/doxygen/files/rel-1.8.13/doxygen-1.8.13.src.tar.gz \
 && tar -xf doxygen.tar.gz \
 && cd doxygen* \
 && cmake . \
 && make -j \
 && make install

RUN curl -Lso flowvr.tar.gz https://gitlab.inria.fr/flowvr/flowvr-ex/-/archive/v2.3.0/flowvr-ex-v2.3.0.tar.gz \
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

RUN curl -Lso netcdf.tar.gz https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz \
 && tar -xf netcdf.tar.gz \
 && cd netcdf* \
 && export CC="$(h5pcc -shlib -show | awk '{print $1}')" \
 && export CFLAGS="$(h5pcc -shlib -show | sed "s%^${CC}\s*%%")" \
 && export LDFLAGS="${CFLAGS}" \
 && ./configure --disable-static --enable-netcdf-4 --disable-dap --disable-utilities --disable-testsets \
 && make -j \
 && make install

FROM pdidevel/xenial_cmake3.5

USER 0

COPY --from=builder /usr/local /usr/local

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    astyle \
    libhdf5-mpich-dev \
    libparaconf-dev \
    libspdlog-dev \
    pybind11-dev \
    zpp \
 && apt-get clean \
 && apt-get autoclean \
 && ldconfig \
 && echo '. /usr/local/bin/flowvr-suite-config.sh' > /etc/profile.d/zzz_enable_flowvr.sh

ENV PDI_LIBS=provided

USER 1001
