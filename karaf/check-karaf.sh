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
#!/bin/sh

KARAF_URL=http://karaf:karaf@localhost:8181/system/console/bundles

get_status_code() {
  curl -s -o /dev/null -w "%{http_code}" ${KARAF_URL}
}

get_bundles_status() {
  curl -s ${KARAF_URL} | grep -o '{"status".*}]}' | jq '.status'
}

echo "Start waiting for Karaf to load features - up to 200 seconds, waiting for 188 active bundles"

/opt/karaf/bin/karaf run &

for i in $(seq 0 60);
do
  sec=$((5 * $i))
  if curl -v -s ${KARAF_URL} 2>&1 | grep -Fq "188 bundles active";
  then
    echo "Karaf loading finished after $sec seconds";
    get_bundles_status
    /opt/karaf/bin/karaf stop
    exit 0;
  else
    status_code=$(get_status_code)
    echo "Karaf loading from $sec sec... response: $status_code";
    if [ "$status_code" -eq 200 ]
    then
      get_bundles_status
    fi;
    sleep 5;
  fi;
done

exit 1;