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

# Set the env params
ENV KARAF_USER karaf
ENV KARAF_UID 8181
ENV JAVA_MAX_MEM 512m
ENV KARAF_EXEC exec
ENV KARAF_VERSION=4.2.0

ARG HEALTHCHECK_PHRASE="204 bundles in total - all 204 bundles active"

COPY download.sh /tmp/download.sh

RUN addgroup -S -g ${KARAF_UID} ${KARAF_USER}; \
    adduser -S -u ${KARAF_UID} -g ${KARAF_USER} ${KARAF_USER}

RUN apk add --update bash tar jq curl && rm -rf /var/cache/apk/* \
    && chmod a+x /tmp/download.sh && sync && /tmp/download.sh && rm /tmp/download.sh \
    && mkdir -p /opt/karaf \
    && tar --strip-components=1 -C /opt/karaf -xzf /tmp/apache-karaf.tar.gz \
    && rm /tmp/apache-karaf.tar.gz \
    && mkdir -p /opt/karaf/data /opt/karaf/data/log \
    && chown -R ${KARAF_USER}.${KARAF_USER} /opt/karaf \
    && echo org.ops4j.pax.url.mvn.defaultRepositories = file:///opt/maven/repository@id=local.app@snapshots  >> /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg

# Copy and unzip AET artifacts
COPY bundles.zip features.zip /tmp/
RUN unzip -o /tmp/bundles.zip -d /opt/karaf/deploy && rm /tmp/bundles.zip \
  && unzip -o /tmp/features.zip -d /opt/karaf/deploy && rm /tmp/features.zip

COPY configs/ /opt/karaf/etc

EXPOSE 1099 8101 8181 44444

USER ${KARAF_USER}

HEALTHCHECK --interval=1m --timeout=10s --start-period=120s \
  CMD curl -v --silent http://karaf:karaf@localhost:8181/system/console/bundles 2>&1 | grep -Fq ${HEALTHCHECK_PHRASE} || exit 1

CMD ["/opt/karaf/bin/karaf", "run"]