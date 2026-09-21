# QGIS image with the QField packaging dependency baked in, so the packaging scripts can
# simply be run: `docker compose run --rm qgis project/scripts/package-qfield.py ...`.

ARG QGIS_VERSION=3.44
FROM qgis/qgis:${QGIS_VERSION}

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --break-system-packages --root-user-action=ignore \
        -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt
