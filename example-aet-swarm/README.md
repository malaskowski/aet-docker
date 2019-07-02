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
Additionally, contains [AET Lighthouse Extension](https://github.com/Skejven/aet-lighthouse-extension)
installed.

### How to run
0. Make sure you meet all [prerequisites](https://github.com/Skejven/aet-docker#prerequisites).
1. Download and unzip [aet-lighthouse-edition](https://bintray.com/skejven/AET/download_file?file_path=https%3A%2Fgithub.com%2FSkejven%2Faet-docker%2Ftree%2Ffeature%2Flighthouse-support%2Flighthouse-aet-swarm.zip).
2. Provide working Lighthouse Server instance
  a) *Recommended way*: 
    - use instructions from the [AET Lighthouse plugin](https://github.com/Skejven/aet-lighthouse-extension/tree/master/lighthouse-server#lighthouse-server-for-aet-collector)
    to run server locally. You may find the zipped server [here](https://github.com/Skejven/aet-lighthouse-extension/releases/download/0.1.0/aet-lighthouse-server.zip).
  b) Build [AET Lighthouse Docker image](https://github.com/Skejven/aet-docker/tree/feature/lighthouse-support/lighthouse-beta) and run it as a container.
2. Download and unzip [aet-lighthouse-edition](https://bintray.com/skejven/AET/download_file?file_path=lighthouse-aet-swarm.zip).
3. Configure `lighthouseInstanceUri` property in the `configs/com.github.skejven.collector.LighthouseCollectorFactory.cfg`.
(It should work OOTB with AET Lighthouse Server running locally)
4. Run `docker stack deploy -c aet-swarm.yml aet` to run AET Stack with Lighthouse plugin.

### Lighthouse extension
Read more about the extension in the repository docs:
- https://github.com/Skejven/aet-lighthouse-extension#lighthouse-extension