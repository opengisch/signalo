


## Environment setup

1. Install Docker (for [Windows](https://docs.docker.com/docker-for-windows/install/))
2. Run the container: `docker run -d -p 5432:5432 --name siro opengisch/siro:unstable`
3. The former command will run an empty model. You can install the demo data by running: `docker exec siro init_db.sh build -d`
4. You need to setup the Postgres service ([documentation](https://qgep.github.io/docs/en/installation-guide/workstation.html#windows-pg-service)) to connect to the database: 
```
[pg_siro]
dbname=siro
user=postgres
password=postgres
host=localhost
```
4. [Download the sources of the project](https://github.com/opengisch/signalisation_verticale/archive/master.zip)
5. Open the QGIS project (located in the sources, under project)
