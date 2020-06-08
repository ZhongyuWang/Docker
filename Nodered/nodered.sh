#!/bin/bash

## Run Nodered
docker volume create nodered
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v nodered:/var/lib/nodered \
    -p 1880:1880 \
    --net=network \
    --name nodered nodered/node-red-docker

# Install packages
docker exec -it nodered npm install --production node-red-dashboard node-red-contrib-python-function node-red-contrib-python3-function
docker restart nodered
