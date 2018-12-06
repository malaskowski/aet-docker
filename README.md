# AET Docker support
<p align="center">
  <img src="https://raw.githubusercontent.com/Cognifide/aet/master/misc/img/aet-logo-black.png?raw=true" alt="AET Logo"/>
</p>

Contains Dockerfiles and example docker swarm configuration to setup local AET instance.

## Minimum requirements
To run AET instance make sure that machine you run it at has at least enabled:

- `2 vCPU`
- `8 GB of memory`

If you plan to run some heavier tests (e.g. multiple suites concurrently) 
or want to get results faster (more concurrently checked pages) adjust your instance resources accordingly.

---

## Local AET instance with docker swarm
> Notice - this instruction guides you how to setup local AET instance using single-node swarm cluster. 
> *This is not production ready setup!*

### What's inside
Example AET stack runs:
- MongoDB container with mounted volume (for persistency)
- Selenium Grid with Hub and 3 Nodes (2 Chrome instances each, totally 6 browsers)
- ActiveMq container
- Browsermob container
- Apache Karaf container with AET core installed (Runner, Workers, Web-API, Datastorage, Executor)
- Apache Server container with AET Report
- [AET suite generator](https://github.com/m-suchorski/suite-generator/tree/feature/suite)

### Prerequisites
- Docker installed on your host (either ["Docker"](https://docs.docker.com/install/) (e.g. Docker for Windows) 
or ["Docker Tools"](https://docs.docker.com/toolbox/overview/)).
- Docker swarm initialized. 
See this [swarm-tutorial: create swarm](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/) for detailed instructions.
  - **TLDR;** If you are using:
    - *Docker*: Run command: `docker swarm init`.
    - *Docker Tools*: Run `docker swarm init --advertise-addr <manager-ip>` where `<manager-ip>` 
is the IP of your docker-machine (usually `192.168.99.100`).

### Running instance
1. Download `aet-swarm.yml` file from the [release](https://github.com/Skejven/aet-docker/releases)
 you want to use and save it in `aet` directory.
2. Check the IP address of your docker instance (e.g. with *Docker Tools* use `docker-machine ip`, with *Docker* it is `localhost`) 
and update `aet-swarm.yml` to point `REPORT_DOMAIN` in `karaf` service to this IP address.
```yaml
...
  karaf:
    ...
    environment:
      - REPORT_DOMAIN=http://192.168.99.100
...
```
3. From `aet` directory run `docker stack deploy -c aet-swarm.yml aet`.
4. Wait about 1-2 minutes until Karaf start finishes.

When it is ready, you should see the information in the [Karaf console](https://github.com/Skejven/aet-docker#available-consoles):

  > Bundle information: 204 bundles in total - all 204 bundles active

You may also check the status of Karaf by executing

```bash
docker ps --format "table {{.Image}}\t{{.Status}}" --filter expose=8181/tcp
```

When you see status `healthy` it means Karaf is running correctly

> IMAGE                     STATUS
> skejven/aet_karaf:0.4.0   Up 20 minutes (healthy)

### Running AET Suite
To run AET Suite simply define `endpointDomain` to AET Karaf ip with `8181` port, e.g.:
> `./aet.sh http://localhost:8181`
or
> ` mvn aet:run -DendpointDomain=http://localhost:8181`

Read more about running AET suite [here](https://github.com/Cognifide/aet/wiki/RunningSuite).


### Upgrading local AET instance using docker swarm
1. Update `aet-swarm.yml` file to the latest version (you will find it in the [latest release](https://github.com/Skejven/aet-docker/releases/latest)).
2. Run `docker stack deploy -c aet-swarm.yml aet`

### Available consoles:
- Selenium grid console:  http://localhost:4444/grid/console
- ActiveMQ console: http://localhost:8161/admin/queues.jsp (credentials: `admin/admin`)
- Karaf console: http://localhost:8181/system/console/bundles (credentials: `karaf/karaf`)
- Suite generator: http://localhost/suite-generator
- AET Report: `http://localhost/report.html?params...`
> Note, that if you are using *Docker Tools* there will be your docker-machine ip instead of `localhost`

---

## Best practice when setting up AET instance
1. Control changes in `aet-swarm.yml` over time! Use version control system (e.g. [GIT](https://git-scm.com/)) to keep tracking changes of your customized `aet-swarm.yml`.
2. If you value your data - reports results and history of running suites, remember about **backing up MongoDB volume**. If you use external MongoDB, also back up its `/data/db` regularly!
3. Provide at least [minimum requirements](#minimum-requirements) machine for your docker cluster.

## Available customization
### External MongoDB
You may run AET with external MongoDB instance (not running on Docker). 
Use Karaf ENV `MONGODB_URI` to setup mongodb uri at the cluster run time.

### Reports app url
Use Karaf ENV `REPORT_DOMAIN` to set custom IP/domain address where AET report is available

## Troubleshooting
### Example visualiser
If you want to see what's deployed on your instance, you may use `dockersamples/visualizer` by running:

```
docker service create \
  --name=viz \
  --publish=8090:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer
 ```

- Visualiser console: `http://localhost:8090`
> Note, that if you are using *Docker Tools* there will be your docker-machine ip instead of `localhost`

### Debugging
To debug bundles on Karaf set environment vairable `KARAF_DEBUG=true` and expose port `5005` on karaf service.

### Logs
You may preview AET logs with `docker service logs aet_karaf -f`.


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
