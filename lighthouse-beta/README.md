> Work In Progress...

# AET Lighthouse Docker image

Since there is still no official Lighthouse Docker image,
this one is forked https://github.com/GoogleChromeLabs/lighthousebot/tree/master/builder 
and adjusted to AET needs.

## Running
Execute:

`docker run -dit -p 5000:5000 --rm --name lighthouse_aet --cap-add=SYS_ADMIN skejven/aet_lighthouse`

## Limitations

### Lighthouse and Docker
Currently Lighthouse does not have official Docker image.
`aet_lighthouse` image is inspired by https://github.com/GoogleChromeLabs/lighthousebot/tree/master/builder.
What more, this image can't be deployed with Docker Swarm, because it requires `SYS_ADMIN` capabilities 
which is not supported in swarm mode.

What is more, Lighthouse on Docker runs quite unstable... If you can use another Lighthouse instance, it will 
probably be a good idea.

### Max 1 url
Yes... This is due to lack of scaling Lighthouse instance. If you play with that module, please remember
to have max 1 url running it in your suite.