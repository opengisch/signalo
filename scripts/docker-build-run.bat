
docker build -f .docker/Dockerfile --tag opengisch/siro .

docker rm -f siro

rem start the server
rem -v mounts the source, so that changes to the datamodel don't require rebuild
rem --rm delete the container when it stops (the data won't be persisted !)
docker run -d -p 5432:5432 -v "C:\Users\lunic\Documents\01_opengis\dev\signalisation_verticale:/src" --name siro opengisch/siro


docker exec -e PGSERVICE=pg_siro siro sh -c "init_db.sh wait"