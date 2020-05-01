# PostgreSQL
* https://hub.docker.com/_/postgres

## Setup postgres
```sh
docker volume create postgres
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v postgres:/var/lib/postgres \
    -p 5432:5432 \
    -e 'POSTGRES_PASSWORD=admin' \
    -e 'POSTGRES_USER=admin' \
    -e 'POSTGRES_DB=postgresdb' \
    --net=network \
    --name postgres postgres
```

## Install psql
```sh
sudo apt-get update
sudo apt-get install postgresql-client
```

## Login Postgres
```sh
psql "host=localhost port=5432 dbname=postgresdb user=admin"
```

```sh
## Create table
CREATE TABLE passengers (  
    id SERIAL NOT NULL PRIMARY KEY, 
    survived INT,
    pclass INT,
    name VARCHAR(255),
    sex TEXT,
    age FLOAT8,
    siblings_spouses INT,
    parents_children INT,
    fare FLOAT8
);

## Dump csv to database
\copy passengers (survived, pclass, name, sex, age, siblings_spouses, parents_children, fare) from 'titanic.csv' CSV HEADER;
```

# TimescaleDB
* https://www.timescale.com/

## Setup Timescale
```sh
docker volume create timescale
docker run -d --restart unless-stopped --log-opt max-size=10m \
    -v timescale:/var/lib/timescale \
    -p 5432:5432 \
    -e 'POSTGRES_PASSWORD=admin' \
    -e 'POSTGRES_USER=admin' \
    -e 'POSTGRES_DB=postgresdb' \
    --net=network \
    --name timescale timescale/timescaledb:latest-pg12
```

## Create table
```sh
CREATE TABLE table (
    name 	text		NOT NULL,
    time        bigint	NOT NULL,
    note    	text		NOT NULL,
    data 	INT		NOT NULL
);

SELECT create_hypertable('table', 'time');
```

## Dump csv to database
```sh
## timescale
timescaledb-parallel-copy --db-name postgresdb --table table --file data.csv --workers 4 --copy-options "CSV"
## with psql
psql -d postgresdb -c "\COPY postgrestable FROM data.csv CSV"
## inside postgres
\copy table FROM data.csv CSV HEADER;
```

## Setup pgAdmin
```sh
docker volume create pgadmin
docker run -d --restart unless-stopped --log-opt max-size=10m \
  -v pgadmin:/var/lib/pgadmin \
  -p 5050:5050 \
  -e 'PGADMIN_DEFAULT_EMAIL=admin@email.com' \
  -e 'PGADMIN_DEFAULT_PASSWORD=admin' \
  -e 'PGADMIN_LISTEN_PORT=5050' \
  --net=network \
  --name pgadmin dpage/pgadmin4
```
