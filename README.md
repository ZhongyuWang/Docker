# Docker
Deployment using Docker.

## Install Docker
```sh
curl -sSL https://get.docker.com | sh
```

### Basic Docker commands
```sh
# Management
docker ps -a
docker logs -f your_service
docker stop your_service
docker rm your_service
docker restart your_service
# Cleaning
docker images -a
docker system prune
docker system prune -a
# Updating
docker pull some_base_image
```

## Prepare local networking
```sh
docker network create network
```

## Development

```bash
sudo docker build --tag container .

sudo docker login

sudo docker tag container container:tag
sudo docker push container:tag

#push manifest - method while waiting for https://github.com/docker/cli/pull/138
sudo docker run --rm -v ~/.docker/config.json:/root/.docker/config.json -v $(pwd):/host weshigbee/manifest-tool push from-spec /host/manifest.yaml
```
