#!/bin/bash

docker run -t pdidevel/xenial_cmake3.5 /bin/bash -c \
                                        "curl -Lso pdi.tar.gz https://gitlab.maisondelasimulation.fr/pdidev/pdi/-/archive/master/pdi-master.tar.gz && \
                                        tar -xf pdi.tar.gz && \
                                        cd pdi* && \
                                        sh tools/build_scripts/xenial_cmake3.5_embedded.sh"