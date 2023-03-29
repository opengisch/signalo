#!/usr/bin/env python3

# 2537994.790,1152561.910

import math
import os

import psycopg2
import psycopg2.extras

pg_service = os.environ.get("PGSERVICE") or "pg_signalo"
conn = psycopg2.connect(f"service={pg_service}")

sign_per_support = 8
step = 100  # in meters
n_per_col = 20


def insert(table, row, schema="signalo_db"):
    cols = ", ".join(row.keys())
    values = ", ".join([f"%({key})s" for key in row.keys()])
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(
        "INSERT INTO {schema}.{table} ({cols}) VALUES ({values}) RETURNING id".format(
            table=table, schema=schema, cols=cols, values=values
        ),
        row,
    )
    return cur.fetchone()[0]


cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
cur.execute("SELECT * FROM signalo_db.vl_official_sign")
rows = cur.fetchall()

i = 0

frame_id = None

for row in rows:
    nth = math.floor(i / sign_per_support)
    if i % sign_per_support == 0:
        x_shift = i % n_per_col
        y_shift = math.floor(i / n_per_col)

        # create support + azimut + frame
        sql = f"SELECT ST_SetSRID(ST_MakePoint({2700000+x_shift*step}, {1300000+y_shift*step}), 2056);"
        cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(sql)
        geom = cur.fetchone()[0]

        support_id = insert("support", {"geometry": geom})

        # create azimut
        azimut_id = insert("azimut", {"azimut": 180, "fk_support": support_id})

        # create frame
        frame_id = insert("frame", {"fk_azimut": azimut_id, "rank": 1})

    # print(support_id, azimut_id, frame_id, 1 + i % n_per_col)
    # create sign
    rank = 1 + i % n_per_col
    insert(
        "sign",
        {
            "fk_frame": frame_id,
            "fk_sign_type": 11,
            "fk_official_sign": row["id"],
            "inscription_1": "texte 1",
            "rank": rank,
        },
    )

    conn.commit()

    i += 1

conn.close()
