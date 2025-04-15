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
        support_id = self.insert_check(
            "support",
            {
                "geometry": self.execute_select(
                    "ST_SetSRID(ST_MakePoint(2600000, 1200000), 2056)"
                )
            },
        )

        azimuts = [100, 200, 300]
        azimut_ids = {}
        frame_ids = {}
        sign_ids = {}

        frame_row = {
            "fk_frame_type": 1,
            "fk_frame_fixing_type": 1,
            "fk_status": 1,
        }
        sign_row = {
            "fk_sign_type": 1,
            "fk_official_sign": "1.01",
            "fk_durability": 1,
            "fk_status": 1,
            "comment": "1",
        }

        for az in azimuts:
            azimut_id = self.insert_check(
                "azimut", {"azimut": az, "fk_support": support_id}
            )
            azimut_ids[az] = azimut_id

            frame_ids[az] = []
            frame_row["fk_azimut"] = azimut_id
            for rf in range(1, 3):
                frame_row["rank"] = rf
                frame_id = self.insert("frame", frame_row)
                frame_ids[az].append(frame_id)

                sign_row["fk_frame"] = frame_id
                sign_ids[frame_id] = []
                for rs in range(1, 6):
                    sign_row["rank"] = rs
                    sign_row["comment"] = str(rs)
                    sign_ids[frame_id].append(self.insert("sign", sign_row))

        self.check(
            {
                "needs_validation": False,
                "support_needs_validation": False,
                "azimuts_need_validation": None,
                "frames_need_validation": None,
                "signs_need_validation": None,
            },
            "vw_validation",
            support_id,
            "signalo_app",
        )

        self.update(
            "sign",
            {"needs_validation": True},
            sign_ids[frame_ids[100][0]][2],
            "signalo_db",
        )

        self.check(
            {
                "needs_validation": True,
                "support_needs_validation": False,
                "azimuts_need_validation": None,
                "frames_need_validation": None,
                "signs_need_validation": [sign_ids[frame_ids[100][0]][2]],
            },
            "vw_validation",
            support_id,
            "signalo_app",
        )

        self.update(
            "sign",
            {"needs_validation": True},
            sign_ids[frame_ids[200][1]][1],
            "signalo_db",
        )

        self.check(
            {
                "needs_validation": True,
                "support_needs_validation": False,
                "azimuts_need_validation": None,
                "frames_need_validation": None,
                "signs_need_validation": sorted(
                    [
                        sign_ids[frame_ids[100][0]][2],
                        sign_ids[frame_ids[200][1]][1],
                    ]
                ),
            },
            "vw_validation",
            support_id,
            "signalo_app",
        )

        self.update(
            "frame", {"needs_validation": True}, frame_ids[300][1], "signalo_db"
        )
        self.update(
            "frame", {"needs_validation": True}, frame_ids[100][1], "signalo_db"
        )
        self.update("azimut", {"needs_validation": True}, azimut_ids[100], "signalo_db")
        self.update("azimut", {"needs_validation": True}, azimut_ids[200], "signalo_db")
        self.update("support", {"needs_validation": True}, support_id, "signalo_db")

        self.check(
            {
                "needs_validation": True,
                "support_needs_validation": True,
                "azimuts_need_validation": sorted([azimut_ids[100], azimut_ids[200]]),
                "frames_need_validation": sorted(
                    [frame_ids[300][1], frame_ids[100][1]]
                ),
                "signs_need_validation": sorted(
                    [
                        sign_ids[frame_ids[100][0]][2],
                        sign_ids[frame_ids[200][1]][1],
                    ]
                ),
            },
            "vw_validation",
            support_id,
            "signalo_app",
        )


if __name__ == "__main__":
    unittest.main()
