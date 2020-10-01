ARG POSTGIS_VERSION=11-2.5
FROM postgis/postgis:${POSTGIS_VERSION}

ARG AUTO_INIT=True

# System deps
RUN apt-get update && apt-get install -y python3 python3-pip libpq-dev wget && apt-get clean

# Python deps
RUN pip3 install pytest psycopg2 pirogue

# Add source
ADD . /src
WORKDIR /src

RUN mkdir /downloads
RUN chown postgres /downloads

# Configure the postgres connections
RUN printf '[siro_release]\ndbname=siro_release\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf
RUN printf '[siro_build]\ndbname=siro_build\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf
RUN printf '[siro_build_pum]\ndbname=siro_build_pum\nuser=postgres\n' >> /etc/postgresql-common/pg_service.conf

RUN chmod +x /src/.docker/init_db.sh
ENV PATH="/src/.docker:${PATH}"

# Execute the main script on database initialization (zzz to be after postgis init)
RUN if [ "x${AUTO_INIT}" = "xTrue" ]; then ln -s /src/.docker/init_db.sh /docker-entrypoint-initdb.d/zzz_init_db.sh; fi

# Some defaults
ENV POSTGRES_PASSWORD=postgres
