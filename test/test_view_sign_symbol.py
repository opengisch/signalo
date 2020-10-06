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

    def test_view_values(self):
        data = [
            {'id': '00000000-0000-0000-eeee-000001010101', 'row': {'azimut': 15, 'final_rank': 1,  'previous_sign_in_frame': None,                                   'next_sign_in_frame': '00000000-0000-0000-eeee-000001010102', 'previous_frame': None,                                   'next_frame': None}},
            {'id': '00000000-0000-0000-eeee-000001010102', 'row': {'azimut': 15, 'final_rank': 2,  'previous_sign_in_frame': '00000000-0000-0000-eeee-000001010101', 'next_sign_in_frame': None,                                   'previous_frame': None,                                   'next_frame': '00000000-0000-0000-ffff-000000010102'}},
            {'id': '00000000-0000-0000-eeee-000001010201', 'row': {'azimut': 15, 'final_rank': 3,  'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': '00000000-0000-0000-ffff-000000010101', 'next_frame': None}},
            {'id': '00000000-0000-0000-eeee-000001020101', 'row': {'azimut': 175, 'final_rank': 1, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': None,                                   'next_frame': '00000000-0000-0000-ffff-000000010202'}},
            {'id': '00000000-0000-0000-eeee-000001020201', 'row': {'azimut': 175, 'final_rank': 2, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': '00000000-0000-0000-ffff-000000010201', 'next_frame': '00000000-0000-0000-ffff-000000010203'}},
            {'id': '00000000-0000-0000-eeee-000001020301', 'row': {'azimut': 175, 'final_rank': 3, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': '00000000-0000-0000-ffff-000000010202', 'next_frame': None}},
            {'id': '00000000-0000-0000-eeee-000001030101', 'row': {'azimut': 235, 'final_rank': 1, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': None,                                   'next_frame': '00000000-0000-0000-ffff-000000010302'}},
            {'id': '00000000-0000-0000-eeee-000001030201', 'row': {'azimut': 235, 'final_rank': 2, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': '00000000-0000-0000-ffff-000000010301', 'next_frame': None}},

            {'id': '00000000-0000-0000-eeee-000002010101', 'row': {'azimut': 47,  'final_rank': 1, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': None,                                   'next_frame': None}},
            {'id': '00000000-0000-0000-eeee-000002020101', 'row': {'azimut': 165, 'final_rank': 1, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': None,                                   'next_frame': '00000000-0000-0000-ffff-000000020202'}},
            {'id': '00000000-0000-0000-eeee-000002020201', 'row': {'azimut': 165, 'final_rank': 2, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': '00000000-0000-0000-eeee-000002020202', 'previous_frame': '00000000-0000-0000-ffff-000000020201', 'next_frame': None}},
            {'id': '00000000-0000-0000-eeee-000002020202', 'row': {'azimut': 165, 'final_rank': 3, 'previous_sign_in_frame': '00000000-0000-0000-eeee-000002020201', 'next_sign_in_frame': '00000000-0000-0000-eeee-000002020203', 'previous_frame': None,                                   'next_frame': None}},
            {'id': '00000000-0000-0000-eeee-000002020203', 'row': {'azimut': 165, 'final_rank': 4, 'previous_sign_in_frame': '00000000-0000-0000-eeee-000002020202', 'next_sign_in_frame': None,                                   'previous_frame': None,                                   'next_frame': '00000000-0000-0000-ffff-000000020203'}},
            {'id': '00000000-0000-0000-eeee-000002020301', 'row': {'azimut': 165, 'final_rank': 5, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': '00000000-0000-0000-ffff-000000020202', 'next_frame': '00000000-0000-0000-ffff-000000020204'}},
            {'id': '00000000-0000-0000-eeee-000002020401', 'row': {'azimut': 165, 'final_rank': 6, 'previous_sign_in_frame': None,                                   'next_sign_in_frame': None,                                   'previous_frame': '00000000-0000-0000-ffff-000000020203', 'next_frame': None}},
        ]
        for row in data:
            self.check(row['row'], 'vw_sign_symbol', row['id'])

    def test_insert(self):
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
            'fk_status': 1
        }

        sign_id = self.insert('vw_sign_symbol', row)
        frame_id = self.select('sign', sign_id)['fk_frame']

        row = {'fk_azimut': azimut_id}
        self.update_check('frame', row, frame_id)

    def test_update(self):
        row = {
            'fk_sign_type': 2,
            'frame_fk_frame_type': 2,
        }

        self.update_check('vw_sign_symbol', row, '00000000-0000-0000-eeee-000002010101')


if __name__ == '__main__':
    unittest.main()
