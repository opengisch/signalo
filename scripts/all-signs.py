#!/usr/bin/env python3

#all_signs.py

import os
import math
import psycopg2
import psycopg2.extras

pg_service = os.environ.get('PGSERVICE') or 'pg_signalo'
conn = psycopg2.connect("service={service}".format(service=pg_service))

sign_per_support = 8
step = 100  # in meters
n_per_col = 7


def insert(table, row, schema='signalo_db'):
    cols = ', '.join(row.keys())
    values = ', '.join(["%({key})s".format(key=key) for key in row.keys()])
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute("INSERT INTO {schema}.{table} ({cols}) VALUES ({values}) RETURNING id"
                .format(table=table, schema=schema, cols=cols, values=values),
                row)
    return cur.fetchone()[0]


cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
cur.execute("SELECT * FROM signalo_db.vl_official_sign order by id")
rows = cur.fetchall()

i = 0

frame_id = None
x_shift = 0
y_shift = 0

for row in rows:
    nth = math.floor(i / sign_per_support)
    if i%sign_per_support == 0:
        x_shift = (i / sign_per_support) % n_per_col
        if x_shift % n_per_col == 0:
            y_shift += 1

        # create support + azimut + frame
        sql = f'SELECT ST_SetSRID(ST_MakePoint({2706400+x_shift*step}, {1302000+y_shift*step}), 2056);'
        cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(sql)
        geom = cur.fetchone()[0]

        support_id = insert('support', {'geometry': geom})

        # create azimut
        azimut_id = insert('azimut', {'azimut': 180, 'fk_support': support_id})

        # create frame
        frame_id = insert('frame', {'fk_azimut': azimut_id, 'rank': 1})

    # create sign
    rank = 1 + i % sign_per_support
    insert('sign', {
        'fk_frame': frame_id,
        'fk_sign_type': 11,
        'fk_official_sign': row['id'],
        'inscription_1': 'texte1',
        'inscription_2': 'inscription2',
        'inscription_3': 'destination3',
        'rank': rank
    })

    conn.commit()
    print(i, rank, x_shift, y_shift)
    i += 1

conn.close()
