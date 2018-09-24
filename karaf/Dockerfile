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

FROM openjdk:8-alpine as build
LABEL maintainer="Maciej Laskowski <skejven@gmail.com>"

# Set the env params
ENV JAVA_MAX_MEM 1024m
ENV JAVA_MIN_MEM 256m
ENV KARAF_EXEC exec

# Set the build params
ARG KARAF_VERSION="4.2.0"
ARG KARAF_DOWNLOAD_SHA512="431ca85af2cc230ffb6ab996cb12034a940e21ac4d03ac04936a4ab5e902c7a4e767f06ad32796d250a30ce090aa1b39d927d84955400803e3ee4e3f5116fea4"
ARG DOWNLOAD_URL="http://archive.apache.org/dist/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz"

RUN apk add --update bash tar jq curl && rm -rf /var/cache/apk/*

RUN curl -fSL -o /tmp/apache-karaf.tar.gz ${DOWNLOAD_URL} \
    && echo "${KARAF_DOWNLOAD_SHA512}  /tmp/apache-karaf.tar.gz" | sha512sum -c - \
    && mkdir -p /opt/karaf \
    && tar --strip-components=1 -C /opt/karaf -xzf /tmp/apache-karaf.tar.gz \
    && rm /tmp/apache-karaf.tar.gz \
    && mkdir -p /opt/karaf/data /opt/karaf/data/log \
    && echo org.ops4j.pax.url.mvn.defaultRepositories = file:///opt/maven/repository@id=local.app@snapshots  >> /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg

# Copy and unzip AET features
COPY features.zip /tmp/
RUN unzip -o /tmp/features.zip -d /opt/karaf/deploy && rm /tmp/features.zip

# Run karaf and wait until it downloads all features
COPY provision-karaf.sh /tmp/provision-karaf.sh
RUN chmod a+x /tmp/provision-karaf.sh && sync && /tmp/provision-karaf.sh

#################################################################################

FROM openjdk:8-alpine as final
LABEL maintainer="Maciej Laskowski <skejven@gmail.com>"

# Set the env params
ENV KARAF_USER karaf
ENV KARAF_UID 8181
ENV JAVA_MAX_MEM 1024m
ENV JAVA_MIN_MEM 256m
ENV KARAF_EXEC exec

RUN addgroup -S -g ${KARAF_UID} ${KARAF_USER}; \
    adduser -S -u ${KARAF_UID} -g ${KARAF_USER} ${KARAF_USER}

RUN apk add --update bash curl tar && rm -rf /var/cache/apk/*

COPY --from=build /opt/karaf /opt/karaf

# Copy and unzip AET bundles
COPY bundles.zip /tmp/
RUN unzip -o /tmp/bundles.zip -d /opt/karaf/deploy && rm /tmp/bundles.zip

COPY configs/ /opt/karaf/etc

RUN chown -R ${KARAF_USER}.${KARAF_USER} /opt/karaf \
    && echo org.ops4j.pax.url.mvn.defaultRepositories = file:///opt/maven/repository@id=local.app@snapshots  >> /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg

EXPOSE 1099 8101 8181 44444

USER ${KARAF_USER}

CMD ["/opt/karaf/bin/karaf", "run"]