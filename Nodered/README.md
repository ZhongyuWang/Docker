# Nodered
* https://nodered.org
* https://hub.docker.com/r/nodered/node-red-docker

## Setup Nodered
```sh
docker volume create nodered
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v nodered:/var/lib/nodered \
    -p 1880:1880 \
    --net=network \
    --name nodered nodered/node-red-docker

# Install packages
docker exec -it nodered npm install --production node-red-dashboard node-red-contrib-python-function node-red-contrib-python3-function
docker restart nodered
```

## Install python dependencies for Alpine image
```sh
apk add --no-cache gcc gfortran musl-dev python-dev python3-dev build-base
```
