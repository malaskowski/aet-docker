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

rm -rf tmp-karaf

git clone https://github.com/apache/karaf.git tmp-karaf \
 && cd tmp-karaf \
 && git checkout tags/karaf-4.2.0 -b karaf-4.2.0-aet \
 && git status


gsed -i 's/http/https/g' assemblies/features/base/pom.xml \
 && gsed -i 's/1.10.1/1.11.14/g' pom.xml

# Build custom Karaf instance with bumped pax.logging to 1.11.14
mvn install -DskipTests -Pfastinstall

mkdir -p tmp-m2/repository/org/apache/karaf
cp -R ~/.m2/repository/org/apache/karaf tmp-m2/repository/org/apache/karaf