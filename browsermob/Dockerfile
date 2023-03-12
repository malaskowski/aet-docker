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

FROM maven:3.8.4-jdk-8 as builder
RUN apt-get update \
    && apt-get install git unzip tzdata \
    && update-ca-certificates

# Clone BMP Proxy fork with log4j fix, see https://github.com/lightbody/browsermob-proxy/pull/891
RUN mkdir -p ~/.ssh/ && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts \
 && git clone https://github.com/cyberstormdotmu/browsermob-proxy.git \
 && cd browsermob-proxy \
 && git reset --hard 6e4afc39c7904f361a712dccff739fa9845cebdc \
 && git status
 
WORKDIR /browsermob-proxy
RUN mvn clean install -DskipTests

#################################################################################

FROM openjdk:8-alpine as final
LABEL maintainer="Maciej Laskowski <https://github.com/malaskowski>"

# Until https://github.com/lightbody/browsermob-proxy/pull/891 is not merged and new BMP released
# Clone the repo with log4j update and build
# # Set the build params
# ARG BMP_VERSION="2.1.4"
# ARG BMP_DOWNLOAD_SHA256="27c4080411adff919586e909c664c73bebb8ba8bfcaea259ce58327222e5e8fb"
# ARG DOWNLOAD_URL="https://github.com/lightbody/browsermob-proxy/releases/download/browsermob-proxy-${BMP_VERSION}/browsermob-proxy-${BMP_VERSION}-bin.zip"

# make sure system is up-to-date
RUN apk update \
    && apk add ca-certificates curl unzip tzdata \
    && update-ca-certificates

# download and install BMP
# RUN curl -fSL -o /tmp/browsermob-proxy.zip ${DOWNLOAD_URL} \
#     && echo "${BMP_DOWNLOAD_SHA256}  /tmp/browsermob-proxy.zip" |  sha256sum -c - \
#     && unzip /tmp/browsermob-proxy.zip -d / \
#     && mv /browsermob-proxy-${BMP_VERSION} /browsermob-proxy \
#     && rm -f /tmp/browsermob-proxy.zip \
#     && rm -rf /var/cache/apk/*

COPY --from=builder /browsermob-proxy/browsermob-dist/target/browsermob-proxy-2.1.6-SNAPSHOT-bin.zip /tmp/

# unzip and install BMP
RUN unzip /tmp/browsermob-proxy-2.1.6-SNAPSHOT-bin.zip -d / \
    && mv /browsermob-proxy-2.1.6-SNAPSHOT /browsermob-proxy \
    && rm -f /tmp/browsermob-proxy.zip \
    && rm -rf /var/cache/apk/*

ENV BMP_PORT="8080" \
    BMP_ADDRESS="0.0.0.0" \
    BMP_PROXY_PORT_RANGE="8281-8681" \
    BMP_PROXY_TTL="0"

CMD /browsermob-proxy/bin/browsermob-proxy -address ${BMP_ADDRESS} -port ${BMP_PORT} -proxyPortRange ${BMP_PROXY_PORT_RANGE} -ttl ${BMP_PROXY_TTL}
