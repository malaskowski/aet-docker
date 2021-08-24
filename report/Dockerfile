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

FROM httpd:2.4.48-alpine
LABEL maintainers="Jan Helak <https://github.com/heljan>, Maciej Laskowski <https://github.com/malaskowski>"


# set the build params
ARG AET_VERSION="3.3.0"
ARG AET_ARTIFACT="report.zip"
ARG AET_ARTIFACT_DOWNLOAD_URL="https://github.com/Cognifide/aet/releases/download/${AET_VERSION}/${AET_ARTIFACT}"

# set the env params
ENV APACHE_USER         www-data
ENV APACHE_WWW_DIR      /usr/local/apache2/htdocs
ENV APACHE_LOG_DIR      /usr/local/apache2/logs
ENV APACHE_CONFIG_DIR   /usr/local/apache2/conf
ENV APACHE_MODULES      "deflate proxy proxy_http"
ENV AET_WEB_API         http://karaf:8181

# clear default content
RUN rm -rf ${APACHE_WWW_DIR}}/*

# enable required modules
RUN for m in $APACHE_MODULES ; do \
  sed -Ei "s~^(#)(LoadModule ${m}_module modules/mod_${m}\.so)~\2~" \
  ${APACHE_CONFIG_DIR}/httpd.conf ;\
  done

# copy aet vhost
COPY aet.conf ${APACHE_CONFIG_DIR}/aet.conf

# append aet vhost into main configuration.
RUN echo "Include conf/aet.conf" >> ${APACHE_CONFIG_DIR}/httpd.conf

# download and deploy AET reports app
RUN wget -O /tmp/${AET_ARTIFACT} ${AET_ARTIFACT_DOWNLOAD_URL} \
  && unzip -o /tmp/${AET_ARTIFACT} -d ${APACHE_WWW_DIR} \
  && rm /tmp/${AET_ARTIFACT}

# Add all extra files
COPY extra ${APACHE_WWW_DIR}

RUN chown -R ${APACHE_USER}:${APACHE_USER} ${APACHE_WWW_DIR}
