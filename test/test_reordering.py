import os
import unittest

import psycopg

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
        cls.conn = psycopg.connect(f"service={pg_service}")

    def test_reorder_signs_in_rank(self):
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
            "fk_azimut": azimut_id,
            "fk_frame_type": 1,
            "fk_frame_fixing_type": 1,
            "fk_status": 1,
        }

        frame_id = self.insert("frame", row)

        row = {
            "fk_frame": frame_id,
            "fk_sign_type": 1,
            "fk_official_sign": "1.01",
            "fk_durability": 1,
            "fk_status": 1,
            "comment": "1",
        }

        row["fk_frame"] = frame_id
        sign_ids = []

        for i in range(1, 6):
            row["rank"] = i
            row["comment"] = str(i)
            sign_ids.append(self.insert("sign", row))

        self.assertEqual(self.count("sign"), sign_count + 5)
        self.assertEqual(self.count("frame"), frame_count + 1)

        self.delete("sign", sign_ids[1])

        self.check({"rank": 1, "comment": "1"}, "sign", sign_ids[0])
        self.check({"rank": 2, "comment": "3"}, "sign", sign_ids[2])
        self.check({"rank": 3, "comment": "4"}, "sign", sign_ids[3])
        self.check({"rank": 4, "comment": "5"}, "sign", sign_ids[4])

    def test_reorder_frames_on_support(self):
        frame_count = self.count("frame")

        support_id = self.insert_check(
            "support",
            {
                "geometry": self.execute_select(
                    "ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)"
                )
            },
        )
        azimut_ids = {
            100: self.insert_check("azimut", {"azimut": 100, "fk_support": support_id}),
            200: self.insert_check("azimut", {"azimut": 200, "fk_support": support_id}),
        }

        frame_ids = {}
        for az in (100, 200):
            frame_ids[az] = {}
            row = {
                "fk_azimut": azimut_ids[az],
                "fk_frame_type": 1,
                "fk_frame_fixing_type": 1,
                "fk_status": 1,
            }
            for i in range(1, 6):
                row["rank"] = i
                row["comment"] = f"{az} {i}"
                frame_ids[az][i] = self.insert("frame", row)

        self.assertEqual(self.count("frame"), frame_count + 10)

        self.delete("frame", frame_ids[100][2])
        self.update("frame", {"fk_azimut": azimut_ids[200]}, frame_ids[100][3])

        self.assertEqual(self.count("frame"), frame_count + 9)

        self.check({"rank": 1, "comment": "100 1"}, "frame", frame_ids[100][1])
        self.check({"rank": 2, "comment": "100 4"}, "frame", frame_ids[100][4])
        self.check({"rank": 3, "comment": "100 5"}, "frame", frame_ids[100][5])
        self.check({"rank": 1, "comment": "200 1"}, "frame", frame_ids[200][1])
        self.check({"rank": 2, "comment": "200 2"}, "frame", frame_ids[200][2])
        self.check({"rank": 3, "comment": "200 3"}, "frame", frame_ids[200][3])
        self.check({"rank": 4, "comment": "200 4"}, "frame", frame_ids[200][4])
        self.check({"rank": 5, "comment": "200 5"}, "frame", frame_ids[200][5])
        self.check({"rank": 6, "comment": "100 3"}, "frame", frame_ids[100][3])


if __name__ == "__main__":
    unittest.main()
