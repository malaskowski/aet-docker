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

FROM ubuntu:16.04
LABEL maintainer="Maciej Laskowski <skejven@gmail.com>"

# Set the env params
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# Set the build params
ARG AET_VERSION="3.2.2"
ARG AET_ARTIFACT="report.zip"
ARG AET_ARTIFACT_DOWNLOAD_URL="https://github.com/Cognifide/aet/releases/download/${AET_VERSION}/${AET_ARTIFACT}"

# make sure system is up-to-date and install apache2
RUN apt-get update && apt-get install -y apache2 unzip curl && apt-get clean && rm -rf /var/lib/apt/lists/*

# configure apache
RUN rm -rf /etc/apache2/sites-available/*
COPY aet.conf /etc/apache2/sites-available/aet.conf
RUN ln -s /etc/apache2/sites-available/aet.conf /etc/apache2/sites-enabled/aet.conf
RUN a2enmod headers && a2enmod proxy && a2enmod proxy_http

RUN rm -rf /var/www/html/*

# download and deploy AET reports app
RUN curl -fSL -o /tmp/${AET_ARTIFACT} ${AET_ARTIFACT_DOWNLOAD_URL} \
  && unzip -o /tmp/${AET_ARTIFACT} -d /var/www/html && rm /tmp/${AET_ARTIFACT}

# deploy AET suite generator
COPY suite-generator-beta.zip /tmp
RUN unzip -o /tmp/suite-generator-beta.zip -d /var/www/html/suite-generator && rm /tmp/suite-generator-beta.zip

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]