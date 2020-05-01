# InfluxDB
* https://www.influxdata.com/

## Setup Influxdb
```sh
docker volume create influxdb
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v influxdb:/var/lib/influxdb \
    -p 8086:8086 \
    -e 'INFLUXDB_BIND_ADDRESS=:8088' \
    -e 'INFLUXDB_HTTP_AUTH_ENABLED=true' \
    --net=network \
    --name influxdb influxdb
```

## Influx users and credentials
* http://docs.influxdata.com/influxdb/v1.7/administration/config/#http-endpoints-settings

```sh
# Create admin user
docker run -it --rm --net=network influxdb curl "http://influxdb:8086/query" --data-urlencode "q=CREATE USER admin WITH PASSWORD 'admin' WITH ALL PRIVILEGES"

# Create database
docker run -it --rm --net=network influxdb curl "http://admin:admin@influxdb:8086/query" --data-urlencode "q=CREATE DATABASE influxdb"

# Create admin for database
docker run -it --rm --net=network influxdb curl "http://admin:admin@influxdb:8086/query" --data-urlencode "q=CREATE USER localadmin WITH PASSWORD 'localadmin'"
docker run -it --rm --net=network influxdb curl "http://admin:admin@influxdb:8086/query" --data-urlencode "q=GRANT ALL ON influxdb TO localadmin"
```

## Setup Chronograf
```sh
docker volume create chronograf
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v chronograf:/var/lib/chronograf \
    -p 8888:8888 \
    -e BASE_PATH="/chronograf" \
    --net=network \
    --name chronograf chronograf --influxdb-url=http://network:8086
```

## Operate data with HTTP API
* https://docs.influxdata.com/influxdb/v1.7/guides/querying_data/
* https://docs.influxdata.com/influxdb/v1.7/guides/writing_data/

```sh
# Create database
curl http://admin:admin@localhost:8086/query --data-urlencode "q=CREATE DATABASE influxdb"

# Write data
curl 'http://admin:admin@localhost:8086/write?db=influxdb' --data-binary 'cpu_load_short,host=server01,region=eu value=0.64 1434055562000000000'

# Writing multiple points
curl 'http://admin:admin@localhost:8086/write?db=influxdb' --data-binary 'cpu_load_short,host=server02 value=0.67
cpu_load_short,host=server02,region=eu value=0.55 1422568543702900257
cpu_load_short,direction=in,host=server01,region=eu value=2.0 1422568543702900257'

# Writing points from a file
curl 'http://admin:admin@localhost:8086/write?db=influxdb' --data-binary @cpu_data.txt

# Query data
curl GET 'http://admin:admin@localhost:8086/query?pretty=true' --data-urlencode "db=influxdb" --data-urlencode "q=SELECT \"value\" FROM \"cpu_load_short\" WHERE \"region\"='eu'"

# Multiple queries
curl GET 'http://admin:admin@localhost:8086/query?pretty=true' --data-urlencode "db=influxdb" --data-urlencode "q=SELECT \"value\" FROM \"cpu_load_short\" WHERE \"region\"='eu';SELECT count(\"value\") FROM \"cpu_load_short\" WHERE \"region\"='eu'"
```

### InfluxDB command line
* https://docs.influxdata.com/influxdb/v1.7/tools/shell/

```sh
# Dump data
nice docker run -it --rm --net=network influxdb influx -host influxdb -database influxdb --username 'admin' -password 'admin' -format=csv -execute "SELECT \"value\" FROM \"cpu_load_short\" WHERE \"region\"='eu'"
```
