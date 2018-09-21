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

### Minimum requirements
When you run full AET system with Docker (including karaf, selenium grit hub and nodes with browsers, mongo, activemq, browsermob) it
is recommended to enable at least:

- `2 vCPU`
- `8 GB of memory`

to make your instance act stably. If you plan to run some heavier tests (e.g. multiple suites concurrently) or want to get results faster (more concurrently checked pages)
adjust your docker cluster appropriately.

1. Download `aet-swarm.yml` file from the [release](https://github.com/Skejven/aet-docker/releases)
 you want to use and save it in `aet` directory.
2. Check the IP of your docker instance (e.g. `docker-machine ip`) and update `REPORT_DOMAIN` in `karaf` service to this ip address.
Alternatively if you have proxy configured and domain enabled, you may set domain configured, set the domain value in `REPORT_DOMAIN`.
3. From `aet` directory run `docker stack deploy -c aet-swarm.yml aet`.
4. Wait until Karaf start and resolve all dependencies (it may take about 1-2 minutes).

When it is ready, you should see the information in the [Karaf console](https://github.com/Skejven/aet-docker#available-consoles):

  > Bundle information: 204 bundles in total - all 204 bundles active

You may also check the status of Karaf by executing

```bash
docker ps --format "table {{.Image}}\t{{.Status}}" --filter expose=8181/tcp
```

When you see status `healthy` it means Karaf is running correctly

> IMAGE                     STATUS
> skejven/aet_karaf:0.4.0   Up 20 minutes (healthy)

## Upgrading
1. Update `aet-swarm.yml` file to the latest version (you will find it in the [latest release](https://github.com/Skejven/aet-docker/releases/latest)).
2. Run `docker stack deploy -c aet-swarm.yml aet`

## Best practice when setting up AET instance
1. Control changes of `aet-swarm.yml` over time! Use version control system (e.g. [GIT](https://git-scm.com/)) to keep tracking changes of your customized `aet-swarm.yml`.
2. If you value your data - reports results and history of running suites, remember about **backing up MongoDB volume**. If you use external MongoDB, also back up its `/data/db` regularly!
3. Provide at least [minimum requirements](https://github.com/Skejven/aet-docker#minimum-requirements) machine for your docker cluster.

## What's inside
Example AET stack runs:
- MongoDB container with mounted volume (for persistency)
- Selenium Grid with Hub and 3 Nodes (2 Chrome instances each, totally 6 browsers)
- ActiveMq container
- Browsermob container
- Apache Karaf container with AET core installed (Runner, Workers, Web-API versions 2.1.7-SNAPSHOT with Chrome support)
- Apache Server container with AET Report
- [AET suite generator](https://github.com/m-suchorski/suite-generator/tree/feature/suite)

### Available consoles:
- Selenium grid console: `http://<docker-machine-ip>:4444/grid/console`
- ActiveMQ console: `http://<docker-machine-ip>:8161/admin/queues.jsp` (credentials: `admin/admin`)
- Karaf console: `http://<docker-machine-ip>:8181/system/console/bundles` (credentials: `karaf/karaf`)
- Suite generator: `http://<docker-machine-ip>/suite-generator`
- AET Report: `http://<docker-machine-ip>/report.html?params...`

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

## Configuration
### External MongoDB
You may run AET with external MongoDB instance (not running on Docker). Use Karaf ENV `MONGODB_URI` to setup mongodb uri at the cluster run time.

### Reports app url customization
Use Karaf ENV `REPORT_DOMAIN` to set custom IP/domain address where AET report is available

## Debugging
To debug bundles on Karaf set environment vairable `KARAF_DEBUG=true` and expose port `5005` on karaf service.

## Logs
You may preview AET logs with `docker service logs aet_karaf -f`.

## Runing AET Suite
To run AET Suite simply define `endpointDomain` to AET Karaf ip with `8181` port, e.g.:
> `./aet.sh http://<docker-machine-ip>:8181`
or
> ` mvn aet:run -DendpointDomain=http://<docker-machine-ip>:8181`

Read more about running AET suite [here](https://github.com/Cognifide/aet/wiki/RunningSuite).

## Building
### Prerequisites
- Docker installed on your host.

1. Clone this repository
2. Build all images using `build.sh local-snapshot`.
You should see following images:
```
    skejven/aet_report
    skejven/aet_karaf
    skejven/aet_browsermob
    skejven/aet_activemq
```

`local-snapshot` param is the version you want to set for your docker images.
Use it later when starting containers.

## ToDo:
- integration-pages docker
- use maven plugin to build images with current code, version etc.
