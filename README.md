# AET Docker support
<p align="center">
  <img src="https://raw.githubusercontent.com/Cognifide/aet/master/misc/img/aet-logo-black.png?raw=true" alt="AET Logo"/>
</p>

Contains Dockerfiles and example docker swarm configuration to setup AET.

> Notice!
> Please mind that this version is only for testing purposes, this is not production ready setup.
> This repository will be later moved to https://github.com/Cognifide/aet

## Running
### Prerequisites
- Docker installed on your host.
- Docker swarm initialized on your docker-machine
  - To initialize docker swarm run command:
  `docker swarm init --advertise-addr <manager-ip>`
  where `<manager-ip>` is the IP of your docker-machine (usually `192.168.99.100`).
  Run `docker node ls` to list all nodes in the swarm (you should see only one node at the moment).

1. Download [`aet-swarm.yml`](https://github.com/Skejven/aet-docker/blob/master/aet-swarm.yml) and save it in `AET` directory.
2. Check the IP of your docker instance (e.g. `docker-machine ip`) and update `REPORT_DOMAIN` in `karaf` service to this ip address.
Alternatively if you have proxy configured and domain enabled, you may set domain configured, set the domain value in `REPORT_DOMAIN`.
3. From `AET` directory run `docker stack deploy -c aet-swarm.yml aet`.
4. Wait until Karaf start and resolve all dependencies (it may take about 1-2 minutes).
When it is ready, you should see the information in the [Karaf console](https://github.com/Skejven/aet-docker#available-consoles):
  > Bundle information: 205 bundles in total - all 205 bundles active

## Upgrading
1. Update [`aet-swarm.yml`](https://github.com/Skejven/aet-docker/blob/master/aet-swarm.yml) to the latest version
2. Run `docker stack deploy -c aet-swarm.yml aet`

## Building
### Prerequisites
- Docker installed on your host.

1. Clone this repository
2. Build all images using `build.sh`.
You should see following images:
```
    skejven/aet_report
    skejven/aet_karaf
    skejven/aet_browsermob
    skejven/aet_activemq
```

## What's inside
Example AET stack runs:
- MongoDB container with mounted volume (for persistency)
- Selenium Grid with Hub and 3 Nodes (2 Chrome instances each, totally 6 browsers)
- ActiveMq container
- Browsermob container
- Apache Karaf container with AET core installed (Runner, Workers, Web-API versions 2.1.7-SNAPSHOT with Chrome support)
- Apache Server container with AET Report

### Available consoles:
- Selenium grid console: `http://<docker-machine-ip>:4444/grid/console`
- ActiveMQ console: `http://<docker-machine-ip>:8161/admin/queues.jsp` (credentials: `admin/admin`)
- Karaf console: `http://<docker-machine-ip>:8181/system/console/bundles` (credentials: `karaf/karaf`)

#### Example visualiser
If you want to see what's deployed on your instance, you may use `dockersamples/visualizer` by running:

```
docker service create \
  --name=viz \
  --publish=8090:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer
 ```

- Visualiser console: `http://<docker-machine-ip>:8090`

## Runing AET Suite
To run AET Suite simply define `endpointDomain` to AET Karaf ip with `8181` port, e.g.:
> ` mvn aet:run -DendpointDomain=http://<docker-machine-ip>:8181`

or

> `./aet.sh http://<docker-machine-ip>:8181`


## ToDo:
- integration-pages docker
- use maven plugin to build images with current code, version etc.