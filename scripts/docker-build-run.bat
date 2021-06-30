
docker build -f .docker/Dockerfile --tag opengisch/signalo .

docker rm -f signalo

rem start the server
rem -v mounts the source, so that changes to the datamodel don't require rebuild
rem --rm delete the container when it stops (the data won't be persisted !)
docker run -d -p 5432:5432 -v "C:\Users\lunic\Documents\01_opengis\dev\signalisation_verticale:/src" --name signalo opengisch/signalo


docker exec -e PGSERVICE=pg_signalo signalo sh -c "init_db.sh wait"