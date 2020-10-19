#!/bin/bash
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
set -e

KARAF_COMMAND=$1

read_secrets() {
  echo "Exporting secrets to env..."
  for file in /run/secrets/KARAF_*; do
    envName=$(echo "$file" | awk -F"KARAF_" '{print $2}')
    envVal="$(<"${file}")"
    echo "Exporting: $envName"
    export "$envName"="$envVal"
  done
}

if [ "$KARAF_COMMAND" = 'run' ]; then
  [ -d "/run/secrets" ] && read_secrets || echo "No secrets configured."
  echo "Running karaf"
  exec /opt/karaf/bin/karaf $KARAF_COMMAND "$@"
fi

exec "$@"
