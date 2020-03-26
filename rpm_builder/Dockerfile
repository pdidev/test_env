FROM fedora

RUN yum install -y --setopt=tsflags=nodocs \
    rpm-build \
    yum-utils \
 && yum clean all -y --enablerepo='*' \
 && rm -f /*.log ${HOME}/*

VOLUME /src
WORKDIR /src

COPY entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
