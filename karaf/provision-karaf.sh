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
#!/bin/sh

TOTA_BUNDLES_TO_WAIT=$1
KARAF_URL=http://karaf:karaf@localhost:8181/system/console/bundles.json

get_status_code() {
  curl -s -o /dev/null -w "%{http_code}" ${KARAF_URL}
}

get_bundles_status() {
  curl -s ${KARAF_URL} | jq '.status'
}

echo "Start waiting for Karaf to load features - up to 00 seconds, waiting for ${TOTA_BUNDLES_TO_WAIT} active bundles"

/opt/karaf/bin/karaf run &

for i in $(seq 0 60);
do
  sec=$((5 * $i))
  if curl -s ${KARAF_URL} 2>&1 | jq '.status' | grep -Fq "${TOTA_BUNDLES_TO_WAIT} bundles active";
  then
    echo "Karaf loading finished after $sec seconds";
    get_bundles_status

    /opt/karaf/bin/client bundle:list -t 0 
    /opt/karaf/bin/client bundle:uninstall 43
    /opt/karaf/bin/client bundle:uninstall 42

    /opt/karaf/bin/karaf stop
    echo "Status: $(/opt/karaf/bin/karaf status)"
    sleep 10;
    echo "*****  /home/karaf/.m2/repository  ****"
    tree /home/karaf/.m2/repository
    echo "***************************************"

    exit 0;
  else
    status_code=$(get_status_code)
    echo "Karaf loading for $sec sec... response: $status_code | (waiting for ${TOTA_BUNDLES_TO_WAIT} active bundles)";
    if [ "$status_code" -eq 200 ]
    then
      get_bundles_status
    fi;
    sleep 5;
  fi;
done

exit 1;