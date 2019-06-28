#
# AET Docker
#
# Copyright (C) 2019 Maciej Laskowski
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
# This Dockerfile is inspired by https://github.com/GoogleChromeLabs/lighthousebot/tree/master/builder,
# originally by Eric Bidelman <ebidel@>
#
FROM node:10-slim

LABEL maintainer="Maciej Laskowski <skejven@gmail.com>"

# Install utilities
RUN apt-get update --fix-missing && apt-get -y upgrade

# Install latest chrome dev package.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /src/*.deb

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Download latest Lighthouse from npm.
# cache bust so we always get the latest version of LH when building the image.
ARG CACHEBUST=1
RUN npm i lighthouse -g

# Install express.
COPY config/package.json .
RUN npm i --production

# Add the simple server.
COPY config/server.js /
RUN chmod +x /server.js

COPY config/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Add a chrome user and setup home dir.
RUN groupadd --system chrome && \
    useradd --system --create-home --gid chrome --groups audio,video chrome && \
    mkdir --parents /home/chrome/reports && \
    chown --recursive chrome:chrome /home/chrome

USER chrome

# Disable Lighthouse error reporting to prevent prompt.
ENV CI=true

EXPOSE 8080

ENTRYPOINT ["dumb-init", "--", "/entrypoint.sh"]
