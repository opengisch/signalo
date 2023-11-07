
FROM imresamu/postgis-arm64:15-3.4 AS base-arm64

FROM postgis/postgis:15-3.4 AS base-amd64

FROM base-$BUILDARCH as common

ARG AUTO_INIT=True

# System deps (bc + exiftool for testing)
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv libpq-dev wget bc && apt-get clean

# Python deps
# Python deps
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
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
RUN if [ "${AUTO_INIT}" = "True" ]; then ln -s /src/.docker/init_db.sh /docker-entrypoint-initdb.d/zzz_init_db.sh; fi

# Some defaults
ENV POSTGRES_PASSWORD=postgres
# otherwise psycopg2 cannot connect
ENV PGSERVICEFILE=/etc/postgresql-common/pg_service.conf

ENV PGSERVICE=pg_signalo
