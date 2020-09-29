FROM pdidevel/centos_cmake3.5

USER 0

COPY --from=pdidevel/centos_libs_cmake3.10 /usr/local /usr/local

RUN yum install -y --setopt=tsflags=nodocs \
    hdf5-openmpi3-devel \
    libyaml-devel \
 && yum clean all -y
RUN echo '. /usr/local/bin/flowvr-suite-config.sh' > /etc/profile.d/zzz_enable_flowvr.sh

ENV PDI_LIBS=provided

USER 1001
