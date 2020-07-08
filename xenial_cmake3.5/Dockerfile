FROM ubuntu:xenial as prebuild

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    apt-transport-https \
 && wget -O /etc/apt/trusted.gpg.d/pdidev-archive-keyring.gpg https://raw.githubusercontent.com/pdidev/pkgs/repo/pdidev-archive-keyring.gpg \
 && echo "deb [ arch=amd64 ] https://raw.githubusercontent.com/pdidev/pkgs/repo/ubuntu/ xenial main" > /etc/apt/sources.list.d/pdi.list \
 && echo "deb-src [ arch=amd64 ] https://raw.githubusercontent.com/pdidev/pkgs/repo/ubuntu/ xenial main" >> /etc/apt/sources.list.d/pdi.list \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends \
    bison \
    build-essential \
    cmake \
    flex \
    freeglut3-dev \
    gfortran \
    libhdf5-mpich-dev \
    libhwloc-dev \
    libmpich-dev \
    mpich \
    pkg-config \
    python-dev \
    python-yaml \
    python3-dev \
    python3-numpy \
    python3-yaml \
    rsync \
    unzip

FROM prebuild as builder

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
    curl

RUN curl -Lso sionlib.tar.gz 'http://apps.fz-juelich.de/jsc/sionlib/download.php?version=1.7.6' \
 && tar -xf sionlib.tar.gz \
 && cd sionlib* \
 && ./configure --prefix=/usr/local --disable-fortran --disable-parutils --disable-cxx --mpi=mpich3 --force-64 \
 && cd build-linux-gomp-mpich3-64 \
 && make -j \
 && make install

# No parallel NetCDF package on ubuntu xenial -> install from source
RUN curl -Lso netcdf.tar.gz 'https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz' \
 && tar -xf netcdf.tar.gz \
 && cd netcdf* \
 && CC=mpicc LDFLAGS=-L/usr/lib/x86_64-linux-gnu/hdf5/mpich CPPFLAGS=-I/usr/include/hdf5/mpich ./configure --prefix=/usr/local --enable-netcdf-4  --disable-dap --disable-utilities --disable-testsets \
 && make -j \
 && make install

FROM prebuild

COPY --from=builder /usr/local /usr/local

ENV HOME /home/default

# MPI_LIB flag for FlowVR example launching script
ENV MPI_LIB mpich
RUN useradd -d ${HOME} -m -u 1001 -U default
USER 1001
WORKDIR ${HOME}
