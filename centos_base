FROM centos/devtoolset-6-toolchain-centos7

USER 0

RUN echo source /etc/profile >> /opt/app-root/etc/scl_enable
SHELL ["/bin/bash", "-l", "-c"]

RUN yum install -y --setopt=tsflags=nodocs \
    bison \
    file \
    flex \
    freeglut-devel \
    hwloc-devel \
    make \
    openmpi3-devel \
    perl \
    python-devel \
    python3-devel \
    python3-pip \
    PyYAML \
    sudo \
    which \
    wget \
 && yum clean all -y

RUN echo module load mpi >> /etc/profile.d/sh.local


USER 1001

ENV OMPI_MCA_rmaps_base_oversubscribe=1
RUN pip3 install --user pyyaml

CMD  ["/bin/bash", "-l"]
