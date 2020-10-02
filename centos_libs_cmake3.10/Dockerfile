FROM pdidevel/centos_cmake3.10 AS builder

USER 0

RUN yum install -y --setopt=tsflags=nodocs \
    hdf5-openmpi3-devel \
    libyaml-devel \
 && yum clean all -y

RUN curl -Lso astyle.tar.gz https://sourceforge.net/projects/astyle/files/astyle/astyle%203.1/astyle_3.1_linux.tar.gz \
 && tar -xf astyle.tar.gz \
 && cd astyle* \
 && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=OFF . \
 && make -j \
 && install -s astyle /usr/local/bin

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

RUN curl -Lso paraconf.tar.gz https://github.com/pdidev/paraconf/archive/0.4.6.tar.gz \
 && tar -xf paraconf.tar.gz \
 && cd paraconf*/paraconf \
 && cmake . \
 && make -j \
 && make install

RUN curl -Lso pybind11.tar.gz https://github.com/pybind/pybind11/archive/v2.4.3.tar.gz \
 && tar -xf pybind11.tar.gz \
 && cd pybind11* \
 && cmake -DPYBIND11_TEST=OFF . \
 && make -j \
 && make install

RUN curl -Lso sionlib.tar.gz 'http://apps.fz-juelich.de/jsc/sionlib/download.php?version=1.7.6' \
 && tar -xf sionlib.tar.gz \
 && cd sionlib* \
 && ./configure --prefix=/usr/local --disable-fortran --disable-parutils --disable-cxx \
 && cd build-linux-gomp-openmpi \
 && make -j \
 && make install

RUN curl -Lso spdlog.tar.gz https://github.com/gabime/spdlog/archive/v1.4.2.tar.gz \
 && tar -xf spdlog.tar.gz \
 && cd spdlog* \
 && cmake -DSPDLOG_BUILD_SHARED=ON -DSPDLOG_BUILD_TESTS=OFF -DSPDLOG_BUILD_BENCH=OFF . \
 && make -j \
 && make install

FROM pdidevel/centos_cmake3.10

USER 0

COPY --from=builder /usr/local /usr/local

RUN yum install -y --setopt=tsflags=nodocs \
    hdf5-openmpi3-devel \
    libyaml-devel \
 && yum clean all -y
RUN echo '. /usr/local/bin/flowvr-suite-config.sh' > /etc/profile.d/zzz_enable_flowvr.sh

ENV PDI_LIBS=provided

USER 1001
