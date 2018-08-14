#
# AET
#
# Copyright (C) 2013 Cognifide Limited
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
MAINTAINER Maciej Laskowski <maciej.laskowski@cognifide.com>

# Set the build params
ARG BMP_VERSION="2.1.4"
ARG BMP_DOWNLOAD_SHA256="27c4080411adff919586e909c664c73bebb8ba8bfcaea259ce58327222e5e8fb"
ARG DOWNLOAD_URL="https://github.com/lightbody/browsermob-proxy/releases/download/browsermob-proxy-${BMP_VERSION}/browsermob-proxy-${BMP_VERSION}-bin.zip"

# make sure system is up-to-date
RUN apk update \
    && apk add ca-certificates curl unzip tzdata \
    && update-ca-certificates

# download and install BMP
RUN curl -fSL -o /tmp/browsermob-proxy.zip ${DOWNLOAD_URL} \
    && echo "${BMP_DOWNLOAD_SHA256}  /tmp/browsermob-proxy.zip" |  sha256sum -c - \
    && unzip /tmp/browsermob-proxy.zip -d / \
    && mv /browsermob-proxy-${BMP_VERSION} /browsermob-proxy \
    && rm -f /tmp/browsermob-proxy.zip \
    && rm -rf /var/cache/apk/*

ENV BMP_PORT="8080" \
    BMP_ADDRESS="0.0.0.0" \
    BMP_PROXY_PORT_RANGE="8281-8681" \
    BMP_PROXY_TTL="0"

CMD /browsermob-proxy/bin/browsermob-proxy -address ${BMP_ADDRESS} -port ${BMP_PORT} -proxyPortRange ${BMP_PROXY_PORT_RANGE} -ttl ${BMP_PROXY_TTL}
