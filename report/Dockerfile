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
FROM alpine:3.8 as build
LABEL maintainer="Maciej Laskowski <skejven@gmail.com>"

# make sure system is up-to-date and install apache2
RUN apk add -U unzip

# deploy AET reports app
COPY report.zip /tmp/
RUN unzip -o /tmp/report.zip -d /tmp/report

#################################################################################

FROM httpd:2.4 as final
LABEL maintainer="Maciej Laskowski <skejven@gmail.com>"

# Set the env params
ENV VHOSTS_ENV=docker

## Cleanup image htdocs
RUN rm /usr/local/apache2/htdocs/index.html

## Copy configs
COPY ./httpd /usr/local/apache2

## Copy AET report files
COPY --from=build /tmp/report /usr/local/apache2/htdocs

VOLUME /usr/local/apache2/logs