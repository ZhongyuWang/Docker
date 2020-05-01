# Grafana
* https://hub.docker.com/r/grafana/grafana

## Setup Grafana
```sh
docker volume create grafana
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -p 3000:3000 \
    -e GF_SECURITY_ADMIN_PASSWORD='grafana' \
    -e GF_INSTALL_PLUGINS=grafana-simple-json-datasource \
    -v grafana:/var/lib/grafana \
    --net=network \
    --name grafana grafana/grafana
```
