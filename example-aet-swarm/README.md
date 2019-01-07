# Local AET instance with docker swarm
This directory contains configuration that enables setting up local AET instance using single-node swarm cluster. 
Note that this is *not production recommended setup*.

AET stack defined in this example runs:
- MongoDB container with mounted volume (for persistency)
- Selenium Grid with Hub and 3 Nodes (2 Chrome instances each, totally 6 browsers)
- AET ActiveMq container
- AET Browsermob container
- AET Apache Karaf container with AET core installed (Runner, Workers, Web-API, Datastorage, Executor)
- AET Apache Server container with AET Report and [AET suite generator](https://github.com/m-suchorski/suite-generator/tree/feature/suite)

## Minimum requirements
To run example AET instance make sure that machine you run it at has at least enabled:

- `2 vCPU`
- `6 GB of memory`

## Available consoles:
- Selenium grid console: http://localhost:4444/grid/console
- ActiveMQ console: http://localhost:8161/admin/queues.jsp (credentials: `admin/admin`)
- Karaf console: http://localhost:8181/system/console/bundles (credentials: `karaf/karaf`)
- Suite generator: http://localhost/suite-generator
- AET Report: `http://localhost/report.html?params...`
> Note, that if you are using *Docker Tools* there will be your docker-machine ip instead of `localhost`

---

## Example instance content

### Docker swarm file
`aet-swarm.yml` - docker swarm file that defines full AET instance

#### AET throughput
AET instance speed depends on direct number of browsers in the system and its configuration.
Lets define `TOTAL_NUMBER_OF_BROWSERS` which will be the number of selenium grid node instances
multiplied by `NODE_MAX_SESSION` set for each node. For this default configuration we have `3`
Selenium Grid instances (`replicas`) with `2` instances of browser available:
```yaml
  chrome:
...
    environment:
...
      - NODE_MAX_SESSION=2
...
    deploy:
      replicas: 3
...
```
So, the `TOTAL_NUMBER_OF_BROWSERS` is `6` (`3 replicas x 2 sessions`).
That number should be set for following configs:
- `maxMessagesInCollectorQueue` in `com.cognifide.aet.runner.RunnerConfiguration.cfg`
- `collectorInstancesNo` in `com.cognifide.aet.worker.listeners.WorkersListenersService.cfg`

### Configs
ToDo
#### com.cognifide.aet.cleaner.CleanerScheduler-main.cfg
read more [here](https://github.com/Cognifide/aet/wiki/Cleaner)
#### com.cognifide.aet.proxy.RestProxyManager.cfg
#### com.cognifide.aet.queues.DefaultJmsConnection.cfg
#### com.cognifide.aet.rest.helpers.ReportConfigurationManager.cfg
#### com.cognifide.aet.runner.MessagesManager.cfg
#### com.cognifide.aet.runner.RunnerConfiguration.cfg
#### com.cognifide.aet.vs.mongodb.MongoDBClient.cfg
#### com.cognifide.aet.worker.drivers.chrome.ChromeWebDriverFactory.cfg
#### com.cognifide.aet.worker.listeners.WorkersListenersService.cfg

---

### Updating example instance
1. Update `aet-swarm.yml` and/or configuration files in the `AET_ROOT`.
2. Configs
  - If you updated any of configs, you need to do one of following actions in order to apply changes on running swarm:
    - Redeploy whole stack by `docker stack rm aet` and bring it back after 1-2 minutes again with `docker stack deploy -c aet-swarm.yml aet`.
    - Update `aet-swarm.yml` `configs` section at the top of a file and in the `karaf` service definition.
   e.g. to update `WorkersListenersService.cfg` modify `worker_cfg_${XYZ}` to `worker_cfg_${XYZ}-v2` in both places.
   Run `docker stack deploy -c aet-swarm.yml aet` to apply config.
    - Alternatively you may do [config rotation](https://docs.docker.com/engine/swarm/configs/#example-rotate-a-config).
   e.g. to update `WorkersListenersService.cfg` run:
      - register new config: `docker config create worker_cfg-v2 configs/com.cognifide.aet.worker.listeners.WorkersListenersService.cfg`
      - update karaf service to use new config instead old one: 
   `docker service update --config-rm aet_worker_cfg_${XYZ} --config-add source=worker_cfg-v2,target=/configs/com.cognifide.aet.worker.listeners.WorkersListenersService.cfg aet_karaf`
   where `${XYZ}` is current version of configuration
       - cleanup old config `docker config rm aet_worker_cfg_${XYZ}`-
  - If you didn't update any configs simply run `docker stack deploy -c aet-swarm.yml aet`.

---

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

---

## FAQ
### How to use external MongoDB
Set `mongoURI` property in the `com.cognifide.aet.vs.mongodb.MongoDBClient.cfg` to point your mongodb instance uri.

### How to set report domain
Set `report-domain` property in the `com.cognifide.aet.rest.helpers.ReportConfigurationManager.cfg` to point the domain.

### How to enable AET instance to run more tests simultaneously
> Notice: those changes will impact your machine resources, be sure to extend number of CPUs and memory
> if you scale up number of browsers.
1. Spawn more browsers by increasing number of Selenium Grid nodes or adding sessions to existing nodes.
Calculate new [`TOTAL_NUMBER_OF_BROWSERS`](#AET-throughput)
2. Set `maxMessagesInCollectorQueue` in `configs/com.cognifide.aet.runner.RunnerConfiguration.cfg` to new `TOTAL_NUMBER_OF_BROWSERS`.
3. Set `collectorInstancesNo` in `configs/com.cognifide.aet.worker.listeners.WorkersListenersService.cfg` to new `TOTAL_NUMBER_OF_BROWSERS`.
4. Update instance (see [how to do it](#updating-example-instance).

### How to use external Selenium Grid nodes
External Selenium Grid node instance should have:
   * [JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) installed
   * [Chrome browser](https://www.google.com/chrome/browser/desktop/) installed
   * [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/downloads) (at least version 2.40)
   * [Selenium Standalone Server](http://www.seleniumhq.org/download/) (at least version 3.41)

Check the address of the machine, where AET stack is running. By default, Selenium Grid HUB should be
available on the `4444` port. Use this IP address when you run node, with command 
(replace `{SGRID_IP}` with this IP address): 

```bash
java -Dwebdriver.chrome.driver="<path/to/chromedriver>" -jar <path/to/selenium-server-standalone.jar> -role node -hub http://{SGRID_IP}:4444/grid/register -browser "browserName=chrome,maxInstances=10" -maxSession 10
```

You should see the message that node joins selenium grid.
Check it via selenium grid console: `http://{SGRID_IP}:4444/grid/console`