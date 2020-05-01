#!/bin/bash

## Run timescale
docker volume create timescale
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v timescale:/var/lib/timescale \
    -p 5432:5432 \
    -e 'POSTGRES_PASSWORD=admin' \
    -e 'POSTGRES_USER=admin' \
    -e 'POSTGRES_DB=postgresdb' \
    --net=network \
    --name timescale timescale/timescaledb:latest-pg12

## Run pgAdmin
docker volume create pgadmin
docker run -d --restart unless-stopped --log-opt max-size=10m \
  -v pgadmin:/var/lib/pgadmin \
  -p 5050:5050 \
  -e 'PGADMIN_DEFAULT_EMAIL=admin@email.com' \
  -e 'PGADMIN_DEFAULT_PASSWORD=admin' \
  -e 'PGADMIN_LISTEN_PORT=5050' \
  --net=network \
  --name pgadmin dpage/pgadmin4
