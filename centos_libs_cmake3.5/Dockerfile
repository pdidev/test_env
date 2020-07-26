FROM pdidevel/centos_cmake3.5

USER 0

COPY --from=pdidevel/centos_libs_cmake3.10 /usr/local /usr/local

RUN yum install -y --setopt=tsflags=nodocs \
    libyaml-devel \
    spdlog-devel \
 && yum clean all -y
RUN echo '. /usr/local/bin/flowvr-suite-config.sh' > /etc/profile.d/zzz_enable_flowvr.sh

USER 1001
