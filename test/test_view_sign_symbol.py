import unittest
import os

import psycopg2
import psycopg2.extras
import decimal
import copy

from .utils import DbTestBase


class TestViews(unittest.TestCase, DbTestBase):

    @classmethod
    def tearDownClass(cls):
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pgservice=os.environ.get('PGSERVICE') or 'siro_build'
        cls.conn = psycopg2.connect("service={service}".format(service=pgservice))

    def test_view(self):
        data = [
            {'id': '00000000-0000-0000-eeee-000001010101', 'row': {'azimut_group': 15, 'final_rank': 1,  'previous_sign_in_frame': None                                  , 'next_sign_in_frame': '00000000-0000-0000-eeee-000001010102', 'previous_frame': None                                  , 'next_frame': None}},
            {'id': '00000000-0000-0000-eeee-000001010102', 'row': {'azimut_group': 15, 'final_rank': 2,  'previous_sign_in_frame': '00000000-0000-0000-eeee-000001010101', 'next_sign_in_frame':  None                                 , 'previous_frame': None                                  , 'next_frame': '00000000-0000-0000-ffff-000000000102'}},
            {'id': '00000000-0000-0000-eeee-000001010201', 'row': {'azimut_group': 15, 'final_rank': 3,  'previous_sign_in_frame': None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': '00000000-0000-0000-ffff-000000000101', 'next_frame': '00000000-0000-0000-ffff-0000000001023'}},
            {'id': '00000000-0000-0000-eeee-000001010301', 'row': {'azimut_group': 15, 'final_rank': 4,  'previous_sign_in_frame': None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': '00000000-0000-0000-ffff-000000000102', 'next_frame': None}},
            {'id': '00000000-0000-0000-eeee-000001020401', 'row': {'azimut_group': 205, 'final_rank': 1, 'previous_sign_in_frame': None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': None                                  , 'next_frame': '00000000-0000-0000-ffff-000000000105'}},
            {'id': '00000000-0000-0000-eeee-000001020501', 'row': {'azimut_group': 205, 'final_rank': 2, 'previous_sign_in_frame': None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': '00000000-0000-0000-ffff-000000000104', 'next_frame': None} },
            {'id': '00000000-0000-0000-eeee-000001030601', 'row': {'azimut_group': 175, 'final_rank': 1, 'previous_sign_in_frame': None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': None                                  , 'next_frame': '00000000-0000-0000-ffff-000000000107'} },
            {'id': '00000000-0000-0000-eeee-000001030701', 'row': {'azimut_group': 175, 'final_rank': 2, 'previous_sign_in_frame': None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': '00000000-0000-0000-ffff-000000000106', 'next_frame': None} },

            {'id': '00000000-0000-0000-eeee-000002010101', 'row': {'azimut_group': 15, 'final_rank': 1,  'previous_sign_in_frame':  None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': , 'next_frame': } },
            {'id': '00000000-0000-0000-eeee-000002010102', 'row': {'azimut_group': 15, 'final_rank': 2,  'previous_sign_in_frame':  None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': , 'next_frame': } },
            {'id': '00000000-0000-0000-eeee-000002010201', 'row': {'azimut_group': 15, 'final_rank': 3,  'previous_sign_in_frame':  None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': , 'next_frame': } },
            {'id': '00000000-0000-0000-eeee-000002010301', 'row': {'azimut_group': 15, 'final_rank': 4,  'previous_sign_in_frame':  None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': , 'next_frame': } },
            {'id': '00000000-0000-0000-eeee-000002020401', 'row': {'azimut_group': 205, 'final_rank': 1, 'previous_sign_in_frame':  None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': , 'next_frame': } },
            {'id': '00000000-0000-0000-eeee-000002020501', 'row': {'azimut_group': 205, 'final_rank': 2, 'previous_sign_in_frame':  None                                  , 'next_sign_in_frame':  None                                 , 'previous_frame': , 'next_frame': } },
        ]

if __name__ == '__main__':
    unittest.main()
