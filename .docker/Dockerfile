ARG POSTGIS_VERSION=11-3.0
FROM postgis/postgis:${POSTGIS_VERSION}

ARG AUTO_INIT=True

# System deps (bc + exiftool for testing)
RUN apt-get update && apt-get install -y python3 python3-pip libpq-dev wget exiftool bc && apt-get clean

# Python deps
RUN pip3 install pytest psycopg2 pirogue

# Add source
ADD . /src
WORKDIR /src

RUN mkdir /downloads
RUN chown postgres /downloads

# Configure the postgres connections
RUN printf '[postgres]\ndbname=postgres\nuser=postgres\n' >> $(pg_config --sysconfdir)/pg_service.conf
RUN printf '[pg_signalo]\ndbname=signalo\nuser=postgres\n' >> $(pg_config --sysconfdir)/pg_service.conf
RUN printf '[pg_signalo_demo]\ndbname=signalo_demo\nuser=postgres\n' >> $(pg_config --sysconfdir)/pg_service.conf

RUN chmod +x /src/.docker/init_db.sh
ENV PATH="/src/.docker:${PATH}"

# Execute the main script on database initialization (zzz to be after postgis init)
RUN if [ "x${AUTO_INIT}" = "xTrue" ]; then ln -s /src/.docker/init_db.sh /docker-entrypoint-initdb.d/zzz_init_db.sh; fi

# Some defaults
ENV POSTGRES_PASSWORD=postgres
# otherwise psycopg2 cannot connect
ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PGSERVICE=pg_signalo
