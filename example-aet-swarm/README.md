# Local AET instance with docker swarm
This directory contains configuration that enables setting up local AET instance using single-node swarm cluster. 
Note that this is *not production recommended setup*.

AET stack defined in this example runs:
- MongoDB container with mounted volume (for persistency)
- Selenium Grid with Hub and 6 Nodes (1 Chrome instances each, totally 6 browsers)
- AET ActiveMq container
- AET Browsermob container
- AET Apache Karaf container with AET core installed (Runner, Workers, Web-API, Datastorage, Executor)
- AET Apache Server container with AET Report.

## Directory structure
```
.
├── aet-swarm.yml
├── bundles
│   ├── aet-lighthouse-extension.jar
│   ├── ...
│   └── aet-custom-extension.jar
├── configs
│   ├── com.cognifide.aet.cleaner.CleanerScheduler-main.cfg
│   ├── ...
│   └── com.github.skejven.collector.LighthouseCollectorFactory.cfg
├── features
│   └── custom-features.xml
├── report
└── secrets
    └── KARAF_EXAMPLE_SECRET
```

- `aet-swarm.yml` - this file contains configuration file to run AET [single-node swarm cluster](https://docs.docker.com/engine/swarm/key-concepts/)
- `bundles` - directory mounted to the `/aet/custom/bundles` in the Karaf service, where Karaf search for custom [OSGi bundles](https://en.wikipedia.org/wiki/OSGi#Bundles), that's the place to put any extra AET extensions
- `configs` - directory mounted to the `/aet/custom/configs` in the Karaf service, contains OSGi components in form of `.cfg` files
- `features` - directory mounted to the `/aet/custom/features in the Karaf service`, contains [Karaf provisioning](https://karaf.apache.org/manual/latest/provisioning) configuration files - called features
- `report` - directory that may contain custom AET report application, if mounted to `/usr/local/apache2/htdocs` volume in the Report service, it will override default [AET Report application](https://github.com/Cognifide/aet/tree/master/report)
- `secrets` - directory contains example [Docker secret](https://docs.docker.com/engine/swarm/secrets/) files. They are scanned before Karaf starts and exported as environment variables. Read more in the [secrets configuration](https://github.com/Skejven/aet-docker#docker-secrets).

## Karaf healthcheck
Karaf's service in this sample docker instance have [healthcheck](https://docs.docker.com/compose/compose-file/#healthcheck). It simply checks the dedicated service's endpoint `/health-check` that responses with `200` when everything is ready, with error code otherwise. If the healthcheck fails, swarm will automatically restart the service.
Read more about this endpoint here: https://fabric8.io/guide/karaf.html#fabric8-karaf-health-checks

## AET Extensions

### Lighthouse
You may configure this AET instance to run Lighthouse reports with [AET Lighthouse Extension](https://github.com/Skejven/aet-lighthouse-extension).
In order to be able to use `<lighthouse/>` extension, you need to provide working Lighthouse Server instance. 
Use instructions from the [AET Lighthouse plugin](https://github.com/Skejven/aet-lighthouse-extension/tree/master/lighthouse-server#lighthouse-server-for-aet-collector) 
to run server locally. You may find the zipped server [here](https://github.com/Skejven/aet-lighthouse-extension/releases/download/0.1.0/aet-lighthouse-server.zip).

Remember to configure `lighthouseInstanceUri` property in the `configs/com.github.skejven.collector.LighthouseCollectorFactory.cfg`.
(It should work OOTB with AET Lighthouse Server running locally).

After that amendments run the swarm as usual: `docker stack deploy -c aet-swarm.yml aet`.

