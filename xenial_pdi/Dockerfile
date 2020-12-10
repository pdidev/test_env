FROM pdidevel/xenial_libs_cmake3.10 AS builder

USER 0

COPY pdi_repo /tmp/pdi_repo/data/

RUN cd /tmp/pdi_repo/data/ \
 && cmake -DDIST_PROFILE=Devel -DUSE_DEFAULT=SYSTEM -DUSE_SIONlib=SYSTEM -DUSE_Bpp=SYSTEM . \
 && make -j \
 && make install

FROM pdidevel/xenial_libs_cmake3.10

USER 0

COPY --from=builder /usr/local /usr/local
RUN echo ". /usr/local/share/pdi/env.bash" > /etc/profile.d/zzz_enable_pdi.sh \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
    hdf5-tools \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/*

USER 1001
