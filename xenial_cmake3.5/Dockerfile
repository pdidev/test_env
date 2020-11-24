FROM ubuntu:xenial as prebuild

COPY bash_run /bin/
ENV BASH_ENV=/etc/profile
SHELL ["/bin/bash", "-c"]

RUN chmod +x /bin/bash_run \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    apt-transport-https \
 && curl -LSfso /etc/apt/trusted.gpg.d/pdidev-archive-keyring.gpg https://raw.githubusercontent.com/pdidev/repo/ubuntu/pdidev-archive-keyring.gpg \
 && echo "deb [ arch=amd64 ] https://raw.githubusercontent.com/pdidev/repo/ubuntu/ xenial main" > /etc/apt/sources.list.d/pdi.list \
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
    libhwloc-dev \
    libmpich-dev \
    libz-dev \
    mpich \
    pkg-config \
    python3-dev \
    python3-numpy \
    python3-pip \
    python3-setuptools \
    python3-venv \
    python3-yaml \
    rsync \
    unzip \
 && curl -LSfso hwloc-nox_1.11.9-1_amd64.deb http://archive.ubuntu.com/ubuntu/pool/universe/h/hwloc/hwloc-nox_1.11.9-1_amd64.deb \
 && curl -LSfso libhwloc5_1.11.9-1_amd64.deb http://archive.ubuntu.com/ubuntu/pool/universe/h/hwloc/libhwloc5_1.11.9-1_amd64.deb \
 && curl -LSfso libhwloc-dev_1.11.9-1_amd64.deb http://archive.ubuntu.com/ubuntu/pool/universe/h/hwloc/libhwloc-dev_1.11.9-1_amd64.deb \
 && dpkg -i libhwloc5_1.11.9-1_amd64.deb hwloc-nox_1.11.9-1_amd64.deb libhwloc-dev_1.11.9-1_amd64.deb\
 && apt-get install -y \
 && apt-get upgrade -y \
 && rm *.deb \
 && apt-get purge -y \
    curl \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/bin/python3 /usr/bin/python

# MPI_LIB flag for FlowVR example launching script
ENV PDI_SYSTEM=docker-ubuntu-xenial
ENV MPI_LIB mpich

ENV HOME /home/default
RUN useradd -d ${HOME} -m -u 1001 -U default
USER 1001
WORKDIR ${HOME}

ENTRYPOINT ["/bin/bash_run"]
CMD ["/bin/bash", "-li"]

FROM prebuild as builder

USER 0

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y curl

RUN curl -LSfso sionlib.tar.gz 'http://apps.fz-juelich.de/jsc/sionlib/download.php?version=1.7.6'
RUN tar -xf sionlib.tar.gz
RUN cd sionlib* \
 && ./configure --prefix=/usr/local --disable-fortran --disable-parutils --disable-cxx --mpi=mpich3 --force-64 \
 && cd build-linux-gomp-mpich3-64 \
 && make -j \
 && make install

FROM prebuild

COPY --from=builder /usr/local /usr/local
