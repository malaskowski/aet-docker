# Local AET instance with docker swarm
This directory contains configuration that enables setting up local AET instance using single-node swarm cluster. 
Note that this is *not production recommended setup*.

AET stack defined in this example runs:
- MongoDB container with mounted volume (for persistency)
- Selenium Grid with Hub and 3 Nodes (2 Chrome instances each, totally 6 browsers)
- AET ActiveMq container
- AET Browsermob container
- AET Apache Karaf container with AET core installed (Runner, Workers, Web-API, Datastorage, Executor)
- AET Apache Server container with AET Report.

## Karaf healthcheck
Karaf's service in this sample docker instance have [healthcheck](https://docs.docker.com/compose/compose-file/#healthcheck). It simply checks the dedicated service's endpoint `/health-check` that responses with `200` when everything is ready, with error code otherwise. If the healthcheck fails, swarm will automatically restart the service.
Read more about this endpoint here: https://fabric8.io/guide/karaf.html#fabric8-karaf-health-checks

## Lighthouse
You may configure this AET instance to run Lighthouse reports with [AET Lighthouse Extension](https://github.com/Skejven/aet-lighthouse-extension).
In order to be able to use `<lighthouse/>` extension, you need to provide working Lighthouse Server instance. Use instructions from the [AET Lighthouse plugin](https://github.com/Skejven/aet-lighthouse-extension/tree/master/lighthouse-server#lighthouse-server-for-aet-collector)
    to run server locally. You may find the zipped server [here](https://github.com/Skejven/aet-lighthouse-extension/releases/download/0.1.0/aet-lighthouse-server.zip).

Remember to configure `lighthouseInstanceUri` property in the `configs/com.github.skejven.collector.LighthouseCollectorFactory.cfg`.
(It should work OOTB with AET Lighthouse Server running locally).

After that amendments run the swarm as usual: `docker stack deploy -c aet-swarm.yml aet`.

### Lighthouse extension
Read more about the extension in the repository docs:
- https://github.com/Skejven/aet-lighthouse-extension#lighthouse-extension
