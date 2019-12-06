FROM pdidev/centos_base

USER 0

RUN yum install -y --setopt=tsflags=nodocs \
    openssh-server \
    openssh-clients \
    epel-release \
 && yum install -y --setopt=tsflags=nodocs \
    cmake3 \
 && yum clean all -y \
 && ln -s "$(which ccmake3)" /usr/bin/ccmake \
 && ln -s "$(which cmake3)"  /usr/bin/cmake \
 && ln -s "$(which cpack3)"  /usr/bin/cpack \
 && ln -s "$(which ctest3)"  /usr/bin/ctest

USER 1001

RUN pip3 install --user numpy mpi4py
