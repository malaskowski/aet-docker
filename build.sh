#!/bin/bash
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

AET_DOCKER_VERSION="$1"

docker build -t malaskowski/aet_client:${AET_DOCKER_VERSION} client/
docker build -t malaskowski/aet_activemq:${AET_DOCKER_VERSION} activemq/
docker build -t malaskowski/aet_browsermob:${AET_DOCKER_VERSION} browsermob/
docker build -t malaskowski/aet_report:${AET_DOCKER_VERSION} report/
docker build -t malaskowski/aet_karaf:${AET_DOCKER_VERSION} karaf/