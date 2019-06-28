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

## Lighthouse special edition

![aet-lighthouse](../misc/aet-lighthouse.png)

### How to run
0. Make sure you meet all [prerequisites](https://github.com/Skejven/aet-docker#prerequisites).
1. Download and unzip [aet-lighthouse-edition](ToDo).
2. Run `./run.sh` to run AET Stack and Lighthouse Docker Container.

### Example usage
To use the `lighthouse` plugin simply put `<lighthouse />` tag in `collect` and `compare` sections.

Example suite:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<suite name="lighthouse" company="aet" project="lighthouse">
    <test name="max-one-url">
        <collect>
            <lighthouse/>
        </collect>
        <compare>
            <lighthouse/>
        </compare>
        <urls>
            <url href="https://github.com"/>
        </urls>
    </test>
</suite>

```

> Yes, you don't need `<open/>`.

### Configuring Lighthouse instance for AET
Using `lighthouse` AET plugin requires configuring `lighthouseInstanceUri` property in the 
`configs/com.github.skejven.collector.LighthouseCollectorFactory.cfg`.
Default value points to the Docker Container started with AET Stack by the `run.sh`.

### Constraints

#### Lighthouse and Docker
Currently Lighthouse does not have official Docker image.
`aet_lighthouse` image is inspired by https://github.com/GoogleChromeLabs/lighthousebot/tree/master/builder.
What more, this image can't be deployed with Docker Swarm, because it requires `SYS_ADMIN` capabilities 
which is not supported in swarm mode.

What is more, Lighthouse on Docker runs quite unstable... If you can use another Lighthouse instance, it will 
probably be a good idea.

#### Max 1 url
Yes... This is due to lack of scaling Lighthouse instance. If you play with that module, please remember
to have max 1 url running it in your suite.