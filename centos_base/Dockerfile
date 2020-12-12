FROM centos:7

COPY bash_run /bin/
ENV BASH_ENV=/etc/profile
SHELL ["/bin/bash", "-c"]

RUN chmod +x /bin/bash_run \
 && rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
 && yum install -y --setopt=tsflags=nodocs \
    yum-utils \
 && yum install -y --setopt=tsflags=nodocs \
    centos-release-scl-rh \
    epel-release \
 && rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 \
 && rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo \
 && yum update -y --setopt=tsflags=nodocs \
 && yum upgrade -y --setopt=tsflags=nodocs \
 && yum install -y --setopt=tsflags=nodocs \
    bison \
    bsdtar \
    devtoolset-7-gcc \
    devtoolset-7-gcc-c++ \
    devtoolset-7-gcc-gfortran \
    file \
    findutils \
    flex \
    freeglut-devel \
    gettext \
    groff-base \
    hwloc-devel \
    make \
    openmpi3-devel \
    perl \
    python-devel \
    python3-devel \
    python3-pip \
    PyYAML \
    rsync \
    scl-utils \
    sudo \
    tar \
    unzip \
    which \
    zlib-devel \
 && yum clean all -y --enablerepo='*' \
 && rm -f /*.log ${HOME}/* \
 && pip3 install --no-cache-dir pyyaml \
 && echo -e '/usr/local/lib\n/usr/local/lib64' > /etc/ld.so.conf.d/local.conf \
 && ldconfig \
 && echo 'btl_base_warn_component_unused=0' >> /etc/openmpi3-x86_64/openmpi-mca-params.conf \
 && echo 'rmaps_base_oversubscribe=1' >> /etc/openmpi3-x86_64/openmpi-mca-params.conf \
 && echo 'module load mpi' > /etc/profile.d/zzz_enable_mpi.sh \
 && echo 'source scl_source enable devtoolset-7' > /etc/profile.d/zzz_enable_devtoolset.sh

ENV PDI_SYSTEM=docker-centos-7
ENV PDI_MPI=openmpi
ENV MPI_LIB=openmpi

ENV HOME /home/default
RUN useradd -d ${HOME} -m -u 1001 -U default
USER 1001
WORKDIR ${HOME}

ENTRYPOINT ["/bin/bash_run"]
CMD ["/bin/bash", "-li"]
