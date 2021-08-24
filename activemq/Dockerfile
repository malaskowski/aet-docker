#
# AET Docker
#
# Copyright (C) 2018 Maciej Laskowski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM openjdk:8-alpine
LABEL maintainer="Maciej Laskowski <https://github.com/malaskowski>"

# Set the build params
ARG VERSION=5.15.2
ARG EXTRACT_DIR=apache-activemq-${VERSION}
ARG FILE_NAME=${EXTRACT_DIR}-bin.tar.gz
ARG DOWNLOAD_URL=https://archive.apache.org/dist/activemq/${VERSION}/${FILE_NAME}

# make sure system is up-to-date
RUN apk add --update bash tar jq curl && rm -rf /var/cache/apk/*

ENV INSTALL_DIR=/opt/activemq
ENV ACTIVEMQ_HOME=${INSTALL_DIR}/${EXTRACT_DIR}

# use default ports exposed by ActiveMQ
ENV TCP_PORT=61616 AMQP_PORT=5672 STOMP_PORT=61613 MQTT_PORT=1883 WS_PORT=61614 UI_PORT=8161 JMX_PORT=11199

# install ActiveMQ
RUN set -x && \
    mkdir -p ${ACTIVEMQ_HOME} && \
    cd ${INSTALL_DIR} && \
    curl -S ${DOWNLOAD_URL} | tar xvz -C ${INSTALL_DIR}

COPY bin/env ${ACTIVEMQ_HOME}/bin/

WORKDIR ${ACTIVEMQ_HOME}

EXPOSE ${TCP_PORT} ${AMQP_PORT} ${STOMP_PORT} ${MQTT_PORT} ${WS_PORT} ${UI_PORT} ${JMX_PORT}

CMD ["/bin/sh", "-c", "bin/activemq console"]