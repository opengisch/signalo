import unittest
import os

import psycopg2
import psycopg2.extras

from .utils import DbTestBase


class TestViews(unittest.TestCase, DbTestBase):

    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pg_service = os.environ.get('PGSERVICE') or 'siro_build'
        cls.conn = psycopg2.connect("service={service}".format(service=pg_service))

    def test_reorder_signs_in_rank(self):

        frame_count = self.count('frame')
        sign_count = self.count('sign')

        support_id = self.insert_check('support', {'geometry': self.execute("ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)")})
        azimut_id = self.insert_check('azimut', {'azimut': 100, 'fk_support': support_id})

        row = {
            'frame_fk_azimut': azimut_id,
            'frame_rank': 1,
            'frame_fk_frame_type': 1,
            'frame_fk_frame_fixing_type': 1,
            'frame_fk_status': 1,
            'sign_rank': 1,
            'fk_sign_type': 1,
            'fk_official_sign': '1.01',
            'fk_durability': 1,
            'fk_status': 1,
            'comment': '1'
        }
        sign_ids = [self.insert('vw_sign_symbol', row)]
        frame_id = self.select('sign', sign_ids[0])['fk_frame']

        row['frame_id'] = frame_id

        for i in range(2, 6):
            row['sign_rank'] = i
            row['comment'] = str(i)
            sign_ids.append(self.insert('vw_sign_symbol', row))

        self.assertEqual(self.count('sign'), sign_count+5)
        self.assertEqual(self.count('frame'), frame_count+1)

        self.delete('vw_sign_symbol', sign_ids[1])

        self.check({'rank': 1, 'comment': '1'}, 'sign', sign_ids[0])
        self.check({'rank': 2, 'comment': '3'}, 'sign', sign_ids[2])
        self.check({'rank': 3, 'comment': '4'}, 'sign', sign_ids[3])
        self.check({'rank': 4, 'comment': '5'}, 'sign', sign_ids[4])


if __name__ == '__main__':
    unittest.main()
