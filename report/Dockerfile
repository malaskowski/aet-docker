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

FROM ubuntu:16.04
LABEL maintainer="Maciej Laskowski <skejven@gmail.com>"

# Set the env params
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# make sure system is up-to-date and install apache2
RUN apt-get update && apt-get install -y apache2 unzip && apt-get clean && rm -rf /var/lib/apt/lists/*

# configure apache
RUN rm -rf /etc/apache2/sites-available/*
COPY aet.conf /etc/apache2/sites-available/aet.conf
RUN ln -s /etc/apache2/sites-available/aet.conf /etc/apache2/sites-enabled/aet.conf
RUN a2enmod headers && a2enmod proxy && a2enmod proxy_http

# deploy AET reports app
RUN rm -rf /var/www/html/*
COPY report.zip /tmp/
RUN unzip -o /tmp/report.zip -d /var/www/html && rm /tmp/report.zip

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]