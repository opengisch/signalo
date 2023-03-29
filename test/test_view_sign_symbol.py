import os
import unittest

import psycopg2
import psycopg2.extras

from .utils import DbTestBase


class TestViews(unittest.TestCase, DbTestBase):
    @classmethod
    def tearDownClass(cls) -> None:
        cls.conn.close()

    @classmethod
    def tearDown(cls) -> None:
        cls.conn.rollback()

    @classmethod
    def setUpClass(cls):
        pg_service = os.environ.get("PGSERVICE") or "signalo"
        cls.conn = psycopg2.connect(f"service={pg_service}")

    def test_view_values(self):
        self.execute(open("test/test_data.sql").read())

        data = [
            {
                "id": "00000000-0000-0000-eeee-000001010101",
                "row": {
                    "azimut": 15,
                    "_final_rank": 1,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": "00000000-0000-0000-eeee-000001010102",
                    "_previous_frame": None,
                    "_next_frame": None,
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000001010102",
                "row": {
                    "azimut": 15,
                    "_final_rank": 2,
                    "_previous_sign_in_frame": "00000000-0000-0000-eeee-000001010101",
                    "_next_sign_in_frame": None,
                    "_previous_frame": None,
                    "_next_frame": "00000000-0000-0000-ffff-000000010102",
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000001010201",
                "row": {
                    "azimut": 15,
                    "_final_rank": 3,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": "00000000-0000-0000-ffff-000000010101",
                    "_next_frame": None,
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000001020101",
                "row": {
                    "azimut": 175,
                    "_final_rank": 1,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": None,
                    "_next_frame": "00000000-0000-0000-ffff-000000010202",
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000001020201",
                "row": {
                    "azimut": 175,
                    "_final_rank": 2,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": "00000000-0000-0000-ffff-000000010201",
                    "_next_frame": "00000000-0000-0000-ffff-000000010203",
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000001020301",
                "row": {
                    "azimut": 175,
                    "_final_rank": 3,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": "00000000-0000-0000-ffff-000000010202",
                    "_next_frame": None,
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000001030101",
                "row": {
                    "azimut": 235,
                    "_final_rank": 1,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": None,
                    "_next_frame": "00000000-0000-0000-ffff-000000010302",
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000001030201",
                "row": {
                    "azimut": 235,
                    "_final_rank": 2,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": "00000000-0000-0000-ffff-000000010301",
                    "_next_frame": None,
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000002010101",
                "row": {
                    "azimut": 47,
                    "_final_rank": 1,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": None,
                    "_next_frame": None,
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000002020101",
                "row": {
                    "azimut": 165,
                    "_final_rank": 1,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": None,
                    "_next_frame": "00000000-0000-0000-ffff-000000020202",
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000002020201",
                "row": {
                    "azimut": 165,
                    "_final_rank": 2,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": "00000000-0000-0000-eeee-000002020202",
                    "_previous_frame": "00000000-0000-0000-ffff-000000020201",
                    "_next_frame": None,
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000002020202",
                "row": {
                    "azimut": 165,
                    "_final_rank": 3,
                    "_previous_sign_in_frame": "00000000-0000-0000-eeee-000002020201",
                    "_next_sign_in_frame": "00000000-0000-0000-eeee-000002020203",
                    "_previous_frame": None,
                    "_next_frame": None,
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000002020203",
                "row": {
                    "azimut": 165,
                    "_final_rank": 4,
                    "_previous_sign_in_frame": "00000000-0000-0000-eeee-000002020202",
                    "_next_sign_in_frame": None,
                    "_previous_frame": None,
                    "_next_frame": "00000000-0000-0000-ffff-000000020203",
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000002020301",
                "row": {
                    "azimut": 165,
                    "_final_rank": 5,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": "00000000-0000-0000-ffff-000000020202",
                    "_next_frame": "00000000-0000-0000-ffff-000000020204",
                },
            },
            {
                "id": "00000000-0000-0000-eeee-000002020401",
                "row": {
                    "azimut": 165,
                    "_final_rank": 6,
                    "_previous_sign_in_frame": None,
                    "_next_sign_in_frame": None,
                    "_previous_frame": "00000000-0000-0000-ffff-000000020203",
                    "_next_frame": None,
                },
            },
        ]
        for row in data:
            self.check(row["row"], "vw_sign_symbol", row["id"], schema="signalo_app")

    def test_insert(self):
        support_id = self.insert_check(
            "support",
            {
                "geometry": self.execute_select(
                    "ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)"
                )
            },
        )
        azimut_id = self.insert_check(
            "azimut", {"azimut": 100, "fk_support": support_id}
        )

        row = {
            "frame_fk_azimut": azimut_id,
            "frame_rank": 1,
            "frame_fk_frame_type": 1,
            "frame_fk_frame_fixing_type": 1,
            "frame_fk_status": 1,
            "sign_rank": 1,
            "fk_sign_type": 1,
            "fk_official_sign": "1.01",
            "fk_durability": 1,
            "fk_status": 1,
        }

        sign_id = self.insert("vw_sign_symbol", row, schema="signalo_app")
        frame_id = self.select("sign", sign_id)["fk_frame"]

        row = {"fk_azimut": azimut_id}
        self.update_check("frame", row, frame_id)

    def test_update(self):
        self.execute(open("test/test_data.sql").read())

        row = {
            "fk_sign_type": 2,
            "frame_fk_frame_type": 2,
        }

        self.update_check(
            "vw_sign_symbol",
            row,
            "00000000-0000-0000-eeee-000002010101",
            schema="signalo_app",
        )

    def test_delete(self):
        frame_count = self.count("frame")
        sign_count = self.count("sign")

        support_id = self.insert_check(
            "support",
            {
                "geometry": self.execute_select(
                    "ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)"
                )
            },
        )
        azimut_id = self.insert_check(
            "azimut", {"azimut": 100, "fk_support": support_id}
        )

        row = {
            "frame_fk_azimut": azimut_id,
            "frame_rank": 1,
            "frame_fk_frame_type": 1,
            "frame_fk_frame_fixing_type": 1,
            "frame_fk_status": 1,
            "sign_rank": 1,
            "fk_sign_type": 1,
            "fk_official_sign": "1.01",
            "fk_durability": 1,
            "fk_status": 1,
        }
        sign_id_1 = self.insert("vw_sign_symbol", row, schema="signalo_app")
        frame_id = self.select("sign", sign_id_1)["fk_frame"]

        row["sign_rank"] = 2
        row["frame_id"] = frame_id

        sign_id_2 = self.insert("vw_sign_symbol", row, schema="signalo_app")

        self.assertEqual(self.count("sign"), sign_count + 2)
        self.assertEqual(self.count("frame"), frame_count + 1)

        self.delete("vw_sign_symbol", sign_id_2, schema="signalo_app")

        self.assertEqual(self.count("sign"), sign_count + 1)
        self.assertEqual(self.count("frame"), frame_count + 1)

        self.delete("vw_sign_symbol", sign_id_1, schema="signalo_app")

        self.assertEqual(self.count("sign"), sign_count)
        self.assertEqual(self.count("frame"), frame_count)


if __name__ == "__main__":
    unittest.main()
