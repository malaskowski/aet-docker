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
#docker stack deploy -c aet-swarm.yml aet

docker rm -f lighthouse_aet
docker run -dit -p 9980:8080 --rm --name lighthouse_aet --cap-add=SYS_ADMIN skejven/aet_lighthouse:0.12.0-lighthouse
