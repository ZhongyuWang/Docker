#!/bin/bash

## Run Grafana
docker volume create grafana
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -p 3000:3000 \
    -e GF_SECURITY_ADMIN_PASSWORD='grafana' \
    -e GF_INSTALL_PLUGINS=grafana-simple-json-datasource \
    -v grafana:/var/lib/grafana \
    --net=network \
    --name grafana grafana/grafana

# Install packages
docker exec -it nodered npm install --production node-red-dashboard node-red-contrib-python-function node-red-contrib-python3-function
docker restart nodered
