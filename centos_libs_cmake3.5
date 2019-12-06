FROM pdidev/centos_cmake3.5

USER 0

COPY --from=pdidev/centos_libs /usr/local /usr/local
RUN echo -e '/usr/local/lib\n/usr/local/lib64' > /etc/ld.so.conf.d/pdi_deps.conf \
 && ldconfig

USER 1001

# FLOWVR ENV
ENV FLOWVR_PREFIX=/usr/local
ENV PATH=/usr/local/share/flowvr/modules/bin:${PATH}
ENV FLOWVR_DATA_PATH /usr/local/share/flowvr-render/data
ENV FLOWVR_PID_LOG_DIR "./.flowvr"
ENV FlowVR_DIR /usr/local/share/flowvr/cmake
ENV PYTHONPATH /usr/local/lib/flowvr/python/
