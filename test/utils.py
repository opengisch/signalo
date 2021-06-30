import unittest

import psycopg2
import psycopg2.extras

class DbTestBase:

    def count(self, table, schema='signalo_od') -> int:
        cur = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute("SELECT COUNT(*) FROM {schema}.{table}".format(table=table, schema=schema))
        return cur.fetchone()[0]

    def select(self, table, id, schema='signalo_od'):
        cur = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute("SELECT * FROM {schema}.{table} WHERE id=%(id)s"
                    .format(table=table, schema=schema),
                    {'id': id})
        return cur.fetchone()

    def execute_select(self, sql: str, params=[]):
        return self.execute('SELECT {};'.format(sql), params=params).fetchone()[0]

    def execute(self, sql: str, params=[]):
        cur = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(sql, params)
        return cur

    def cursor(self):
        return self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    def insert(self, table, row, schema='signalo_od'):
        cur = self.conn.cursor()
        cols = ', '.join(row.keys())
        values = ', '.join(["%({key})s".format(key=key) for key in row.keys()])
        cur.execute("INSERT INTO {schema}.{table} ({cols}) VALUES ({values}) RETURNING id"
                    .format(table=table, schema=schema, cols=cols, values=values),
                    row)
        return cur.fetchone()[0]

    def update(self, table, row, id, schema='signalo_od'):
        cur = self.conn.cursor()
        cols = ','.join(['{key}=%({key})s'.format(key=key) for key in row.keys()])
        row['id'] = id
        cur.execute("UPDATE {schema}.{table} SET {cols} WHERE id=%(id)s"
                    .format(table=table, schema=schema, cols=cols),
                    row)

    def delete(self, table, id, schema='signalo_od'):
        cur = self.conn.cursor()
        cur.execute("DELETE FROM {schema}.{table} WHERE id=%s"
                    .format(table=table, schema=schema), [id])

    def insert_check(self, table, row, expected_row=None, schema='signalo_od'):
        id = self.insert(table, row, schema)
        result = self.select(table, id, schema)

        assert result, id

        if expected_row:
            row = expected_row

        self.check_result(row, result, table, 'insert', schema)

        return id

    def update_check(self, table, row, id, schema='signalo_od'):
        self.update(table, row, id, schema)
        result = self.select(table, id, schema)
        self.check_result(row, result, table, 'update', schema)

    def check(self, expected, table, id, schema='signalo_od'):
        result = self.select(table, id, schema)
        self.check_result(expected, result, table, 'update', schema)

    def check_result(self, expected, result, table, test_name, schema='signalo_od'):
        # TODO: don't convert to unicode, type inference for smallint is
        # currently broken, that's the reason at the moment.
        self.assertTrue(result, "No result set received.")

        for key, value in expected.items():
          self.assertEqual(str(result[key]), str(value), """
             ========================================================

             Data: {expected}

             ========================================================

             Failed {test_name} test on
             Table: "{table}"
             Schema: "{schema}"
             Field: "{key}"
               expected: {expected_value} ({expected_type})
               result: {result_value} ({result_type})

             ========================================================
            """.format(
                  expected = repr(expected),
                  test_name = test_name,
                  table = table,
                  schema = schema,
                  key = key,
                  expected_value = value,
                  result_value = result[key],
                  expected_type = type(value),
                  result_type = type(result[key])
              ))

    def make_line(self, x1, y1, z1, x2, y2, z2, srid=2056):
        """
        Helper to make 3D line geometries
        """
        return self.execute_select('ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(%s, %s, %s), ST_MakePoint(%s, %s, %s)), %s))', [x1, y1, z1, x2, y2, z2, srid])

    def make_line_2d(self, x1, y1, x2, y2, srid=2056):
        """
        Helper to make 2D line geometries
        """
        return self.execute_select('ST_ForceCurve(ST_SetSrid(ST_MakeLine(ST_MakePoint(%s, %s), ST_MakePoint(%s, %s)), %s))', [x1, y1, x2, y2, srid])

    def make_point(self, x, y, z, srid=2056):
        """
        Helper to make 3D point geometries
        """
        return self.execute_select('ST_SetSrid(ST_MakePoint(%s, %s, %s), %s)', [x, y, z, srid])

    def make_point_2d(self, x, y, z=None, srid=2056):
        """
        Helper to make 2D point geometries
        """
        return self.execute_select('ST_SetSrid(ST_MakePoint(%s, %s), %s)', [x, y, srid])
