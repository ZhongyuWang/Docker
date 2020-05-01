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
