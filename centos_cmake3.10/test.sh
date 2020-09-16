#!/bin/bash

docker run -t pdidevel/centos_cmake3.10 /bin/bash -c \
                                        "curl -Lso pdi.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/master/pdi-master.tar.gz && \
                                        tar -xf pdi.tar.gz && \
                                        cd pdi* && \
                                        sh tools/build_scripts/centos_cmake3.10_embedded.sh"
