FROM ubuntu:xenial

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

ENV HOME /home/default
RUN useradd -d ${HOME} -m -u 1001 -U default
USER 1001
WORKDIR ${HOME}
