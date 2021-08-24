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

FROM openjdk:8-alpine as build
LABEL maintainer="Maciej Laskowski <https://github.com/malaskowski>"

# Set the env params
ENV JAVA_MAX_MEM 1024m
ENV JAVA_MIN_MEM 256m
ENV KARAF_EXEC exec

# Set the build params
ARG KARAF_VERSION="4.2.0"
ARG KARAF_DOWNLOAD_SHA512="431ca85af2cc230ffb6ab996cb12034a940e21ac4d03ac04936a4ab5e902c7a4e767f06ad32796d250a30ce090aa1b39d927d84955400803e3ee4e3f5116fea4"
ARG KARAF_DOWNLOAD_URL="http://archive.apache.org/dist/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz"

ARG AET_VERSION="3.3.0"
ARG AET_ARTIFACT="features.zip"
ARG AET_ARTIFACT_DOWNLOAD_URL="https://github.com/Cognifide/aet/releases/download/${AET_VERSION}/${AET_ARTIFACT}"

RUN apk add --update bash tar jq curl tree && rm -rf /var/cache/apk/*

RUN curl -fSL -o /tmp/apache-karaf.tar.gz ${KARAF_DOWNLOAD_URL} \
    && echo "${KARAF_DOWNLOAD_SHA512}  /tmp/apache-karaf.tar.gz" | sha512sum -c - \
    && mkdir -p /opt/karaf \
    && tar --strip-components=1 -C /opt/karaf -xzf /tmp/apache-karaf.tar.gz \
    && rm /tmp/apache-karaf.tar.gz \
    && mkdir -p /opt/karaf/data /opt/karaf/data/log \
    && echo org.ops4j.pax.url.mvn.defaultRepositories = file:///opt/maven/repository@id=local.app@snapshots  >> /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg \
    && sed -i "s+http://+https://+g" /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg \
    && echo org.ops4j.pax.url.mvn.localRepository = file:///home/karaf/.m2/repository  >> /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg

# download and unzip AET features
RUN curl -fSL -o /tmp/${AET_ARTIFACT} ${AET_ARTIFACT_DOWNLOAD_URL} \
  && unzip -o /tmp/${AET_ARTIFACT} -d /opt/karaf/deploy && rm /tmp/${AET_ARTIFACT}

COPY features/aet-healthcheck-features.xml /opt/karaf/deploy/aet-healthcheck-features.xml

# Run karaf and wait until it downloads all features
COPY provision-karaf.sh /tmp/provision-karaf.sh
RUN chmod a+x /tmp/provision-karaf.sh && sync && /tmp/provision-karaf.sh

#################################################################################

FROM openjdk:8-alpine as final
LABEL maintainer="Maciej Laskowski <https://github.com/malaskowski>"

# Set the env params
ENV KARAF_USER karaf
ENV KARAF_UID 8181
ENV JAVA_MAX_MEM 1024m
ENV JAVA_MIN_MEM 256m
ENV KARAF_EXEC exec

# Set the build params
ARG AET_VERSION="3.3.0"
ARG AET_ARTIFACT="bundles.zip"
ARG AET_ARTIFACT_DOWNLOAD_URL="https://github.com/Cognifide/aet/releases/download/${AET_VERSION}/${AET_ARTIFACT}"

RUN addgroup -S -g ${KARAF_UID} ${KARAF_USER}; \
    adduser -S -u ${KARAF_UID} -g ${KARAF_USER} ${KARAF_USER}

RUN apk add --update bash jq curl tar && rm -rf /var/cache/apk/*

COPY --from=build /opt/karaf /opt/karaf

COPY --from=build /home/karaf/.m2/repository /home/karaf/.m2/repository
RUN chown -R ${KARAF_USER}.${KARAF_USER} /home/karaf/.m2

# Copy Karaf config to watch for AET artifacts
COPY etc/*.cfg /opt/karaf/etc/

# Create AET artifacts deployment structure
RUN mkdir -p /aet/core /aet/core/bundles /aet/core/features /aet/extra /aet/extra/bundles /aet/extra/configs /aet/extra/features \
  && chown -R ${KARAF_USER}.${KARAF_USER} /aet

# Download and unzip AET bundles
RUN curl -fSL -o /tmp/${AET_ARTIFACT} ${AET_ARTIFACT_DOWNLOAD_URL} \
  && unzip -o /tmp/${AET_ARTIFACT} -d /aet/core/bundles && rm /tmp/${AET_ARTIFACT} \
  && chown -R ${KARAF_USER}.${KARAF_USER} /aet/core/bundles \
  && chown -R ${KARAF_USER}.${KARAF_USER} /aet/extra/bundles

# Move AET features files into the right place
RUN mv /opt/karaf/deploy/aet-*.xml /aet/core/features \
  && chown -R ${KARAF_USER}.${KARAF_USER} /aet/core/features \
  && chown -R ${KARAF_USER}.${KARAF_USER} /aet/extra/features

RUN chown -R ${KARAF_USER}.${KARAF_USER} /opt/karaf

COPY entrypoint.sh /opt/karaf/entrypoint.sh
RUN chmod a+x /opt/karaf/entrypoint.sh && chown -R ${KARAF_USER}.${KARAF_USER} /opt/karaf/entrypoint.sh

EXPOSE 1099 8101 8181 44444

USER ${KARAF_USER}

ENTRYPOINT ["/opt/karaf/entrypoint.sh"]
CMD ["run"]