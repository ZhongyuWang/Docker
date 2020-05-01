#!/bin/bash

## Run influxdb docker
docker volume create influxdb
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v influxdb:/var/lib/influxdb \
    -p 8086:8086 \
    -e 'INFLUXDB_BIND_ADDRESS=:8088' \
    -e 'INFLUXDB_HTTP_AUTH_ENABLED=true' \
    --net=network \
    --name influxdb influxdb

## Create admin user
docker run -it --rm --net=network influxdb curl "http://influxdb:8086/query" --data-urlencode "q=CREATE USER admin WITH PASSWORD 'admin' WITH ALL PRIVILEGES"

## Create database
docker run -it --rm --net=network influxdb curl "http://admin:admin@influxdb:8086/query" --data-urlencode "q=CREATE DATABASE influxdb"

## Create admin for database
docker run -it --rm --net=network influxdb curl "http://admin:admin@influxdb:8086/query" --data-urlencode "q=CREATE USER localadmin WITH PASSWORD 'localadmin'"
docker run -it --rm --net=network influxdb curl "http://admin:admin@influxdb:8086/query" --data-urlencode "q=GRANT ALL ON influxdb TO localadmin"

## Run chronograf docker
docker volume create chronograf
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v chronograf:/var/lib/chronograf \
    -p 8888:8888 \
    -e BASE_PATH="/chronograf" \
    --net=network \
    --name chronograf chronograf --influxdb-url=http://network:8086
