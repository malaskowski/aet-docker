#
# AET Docker
#
# Copyright (C) 2020 Maciej Laskowski
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

FROM alpine:3.14
LABEL maintainer="Maciej Laskowski <https://github.com/malaskowski>"

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    libxml2-utils

# Download AET bash client and sample suite
RUN mkdir -p /aet/client \
  && curl -sS https://raw.githubusercontent.com/Cognifide/aet/master/client/client-scripts/aet.sh > /aet/client/aet.sh \
  && chmod +x /aet/client/aet.sh

# Sample suite
RUN mkdir -p /aet/suite
COPY ./example.xml /aet/suite/example.xml
VOLUME /aet/suite

# Report
RUN mkdir -p /aet/report
VOLUME /aet/report

WORKDIR /aet/report

ENTRYPOINT ["/aet/client/aet.sh"]
CMD ["http://host.docker.internal:8181", "/aet/suite/example.xml"]
