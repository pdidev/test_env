FROM ubuntu:xenial as prebuild

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    apt-transport-https \
 && curl -Lso /etc/apt/trusted.gpg.d/pdidev-archive-keyring.gpg https://raw.githubusercontent.com/pdidev/pkgs/repo/pdidev-archive-keyring.gpg \
 && echo "deb [ arch=amd64 ] https://raw.githubusercontent.com/pdidev/pkgs/repo/ubuntu/ xenial main" > /etc/apt/sources.list.d/pdi.list \
 && echo "deb-src [ arch=amd64 ] https://raw.githubusercontent.com/pdidev/pkgs/repo/ubuntu/ xenial main" >> /etc/apt/sources.list.d/pdi.list \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
    bison \
    build-essential \
    cmake \
    file \
    flex \
    freeglut3-dev \
    gfortran \
    libhdf5-mpich-dev \
    libhwloc-dev \
    libmpich-dev \
    libz-dev \
    mpich \
    pkg-config \
    python-dev \
    python-yaml \
    python3-dev \
    python3-numpy \
    python3-yaml \
    rsync \
    unzip \
 && curl -Lso hwloc-nox_1.11.9-1_amd64.deb http://archive.ubuntu.com/ubuntu/pool/universe/h/hwloc/hwloc-nox_1.11.9-1_amd64.deb \
 && curl -Lso libhwloc5_1.11.9-1_amd64.deb http://archive.ubuntu.com/ubuntu/pool/universe/h/hwloc/libhwloc5_1.11.9-1_amd64.deb \
 && curl -Lso libhwloc-dev_1.11.9-1_amd64.deb http://archive.ubuntu.com/ubuntu/pool/universe/h/hwloc/libhwloc-dev_1.11.9-1_amd64.deb \
 && dpkg -i libhwloc5_1.11.9-1_amd64.deb hwloc-nox_1.11.9-1_amd64.deb libhwloc-dev_1.11.9-1_amd64.deb\
 && apt-get install -y \
 && apt-get upgrade -y \
 && rm *.deb \
 && apt-get purge -y \
    curl \
 && apt-get autoremove -y \
 && apt-get clean \
 && apt-get autoclean

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

FROM prebuild

COPY --from=builder /usr/local /usr/local

ENV HOME /home/default

# MPI_LIB flag for FlowVR example launching script
ENV MPI_LIB mpich
RUN apt-get install -y curl && useradd -d ${HOME} -m -u 1001 -U default
USER 1001
WORKDIR ${HOME}
