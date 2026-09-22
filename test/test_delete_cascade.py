import os
import unittest

import psycopg

from .utils import DbTestBase


class TestDeleteCascade(unittest.TestCase, DbTestBase):
    """Deleting a support, azimut or frame must cascade to its children.

    Regression test: deleting a pre-existing frame that still holds signs
    raised a foreign key violation, which made QFieldSync abort the whole
    import (see changelog 1.4_03_delete_cascade.sql).
    """

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

    def create_hierarchy(self):
        support_id = self.insert(
            "support",
            {
                "geometry": self.execute_select(
                    "ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)"
                )
            },
        )
        azimut_id = self.insert("azimut", {"azimut": 100, "fk_support": support_id})
        frame_id = self.insert(
            "frame",
            {
                "fk_azimut": azimut_id,
                "fk_frame_type": 1,
                "fk_frame_fixing_type": 1,
                "fk_status": 1,
            },
        )
        sign_ids = [
            self.insert(
                "sign",
                {
                    "fk_frame": frame_id,
                    "fk_sign_type": 1,
                    "fk_official_sign": "1.01",
                    "fk_durability": 1,
                    "fk_status": 1,
                    "rank": i,
                },
            )
            for i in range(1, 4)
        ]
        return support_id, azimut_id, frame_id, sign_ids

    def test_delete_frame_cascades_to_signs(self):
        _, azimut_id, frame_id, sign_ids = self.create_hierarchy()

        self.execute("DELETE FROM signalo_db.frame WHERE id=%s", [frame_id])

        self.assertIsNone(self.select("frame", frame_id))
        for sign_id in sign_ids:
            self.assertIsNone(self.select("sign", sign_id))
        # azimut is untouched
        self.assertIsNotNone(self.select("azimut", azimut_id))

    def test_delete_support_cascades_to_hierarchy(self):
        support_id, azimut_id, frame_id, sign_ids = self.create_hierarchy()

        self.execute("DELETE FROM signalo_db.support WHERE id=%s", [support_id])

        self.assertIsNone(self.select("support", support_id))
        self.assertIsNone(self.select("azimut", azimut_id))
        self.assertIsNone(self.select("frame", frame_id))
        for sign_id in sign_ids:
            self.assertIsNone(self.select("sign", sign_id))


if __name__ == "__main__":
    unittest.main()
