FROM centos:7

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
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
 && yum clean all -y --enablerepo='*' \
 && rm -f /*.log ${HOME}/*
RUN pip3 install --no-cache-dir pyyaml
RUN echo -e '/usr/local/lib\n/usr/local/lib64' > /etc/ld.so.conf.d/local.conf \
 && ldconfig

RUN echo -e 'module load mpi\nexport OMPI_MCA_rmaps_base_oversubscribe=1' > /etc/profile.d/zzz_enable_mpi.sh

ENV HOME /home/default
RUN useradd -d ${HOME} -m -u 1001 -U default
USER 1001
WORKDIR ${HOME}

ENV BASH_ENV=/etc/profile
SHELL ["/usr/bin/scl", "enable", "devtoolset-7", "--", "/bin/bash", "-c"]
ENTRYPOINT ["/usr/bin/scl", "enable", "devtoolset-7", "--"]
CMD ["/bin/bash"]
