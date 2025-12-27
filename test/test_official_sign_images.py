from __future__ import annotations

import os
import re
from pathlib import Path

import psycopg
import psycopg.rows
import pytest

_NUM_UNIT = re.compile(
    r"^\s*([+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?)\s*([a-zA-Z%]*)\s*$"
)

# SVG/CSS absolute unit conversions (CSS px = 1/96 in).
# We only need ratios, but converting to px makes mixed-unit SVGs behave sensibly.
_UNIT_TO_PX = {
    "": 1.0,
    "px": 1.0,
    "in": 96.0,
    "cm": 96.0 / 2.54,
    "mm": 96.0 / 25.4,
    "pt": 96.0 / 72.0,
    "pc": 16.0,  # 1pc = 12pt = 16px
}


def _parse_length_to_px(value: str | None) -> float | None:
    if value is None:
        return None
    match = _NUM_UNIT.match(value)
    if not match:
        return None

    number = float(match.group(1))
    unit = match.group(2).lower()

    if unit == "%":
        return None

    # Relative/viewport-dependent units: not resolvable without layout context.
    if unit in {"em", "ex", "ch", "rem", "vw", "vh", "vmin", "vmax"}:
        return None

    factor = _UNIT_TO_PX.get(unit)
    if factor is None:
        return None

    return number * factor


def svg_size_px(path: Path) -> tuple[float, float]:
    """Return SVG (width_px, height_px).

    Strategy:
    - If width/height are present and absolute: use them.
    - Else fall back to viewBox width/height.

    Raises ValueError if no concrete size can be inferred.
    """

    import xml.etree.ElementTree as ET

    tree = ET.parse(path)
    root = tree.getroot()

    width_attr = root.get("width")
    height_attr = root.get("height")

    width = _parse_length_to_px(width_attr)
    height = _parse_length_to_px(height_attr)

    if width is not None and height is not None and width > 0 and height > 0:
        return (width, height)

    view_box = root.get("viewBox")
    if view_box:
        parts = re.split(r"[,\s]+", view_box.strip())
        if len(parts) == 4:
            _, _, vb_w, vb_h = map(float, parts)
            if vb_w > 0 and vb_h > 0:
                return (vb_w, vb_h)

    raise ValueError(
        f"Cannot determine a concrete size for SVG {str(path)!r}: "
        f"width/height are missing or relative, and viewBox is missing/invalid."
    )


@pytest.fixture(scope="session")
def pg_conn():
    pg_service = os.environ.get("PGSERVICE") or "signalo"
    try:
        conn = psycopg.connect(f"service={pg_service}")
    except Exception as exc:  # pragma: no cover
        pytest.skip(f"Postgres not available via PGSERVICE={pg_service!r}: {exc}")

    yield conn

    conn.close()


def _images_dir(img_dir: str) -> Path:
    return (
        Path(__file__).resolve().parent / "../project/images/official" / img_dir
    ).resolve()


def _count_usage(conn, image_name: str) -> int:
    sql = (
        "SELECT COUNT(id) "
        "FROM signalo_db.vl_official_sign "
        "WHERE img_de=%s OR img_fr=%s OR img_it=%s OR img_ro=%s "
        "OR img_de_right=%s OR img_fr_right=%s OR img_it_right=%s OR img_ro_right=%s"
    )

    with conn.cursor() as cur:
        cur.execute(sql, [image_name] * 8)
        return int(cur.fetchone()[0])


def _get_expected_size(conn, image_name: str) -> tuple[float, float]:
    sql = (
        "SELECT img_width, img_height "
        "FROM signalo_db.vl_official_sign "
        "WHERE img_de=%s OR img_fr=%s OR img_it=%s OR img_ro=%s "
        "OR img_de_right=%s OR img_fr_right=%s OR img_it_right=%s OR img_ro_right=%s "
        "LIMIT 2"
    )

    with conn.cursor() as cur:
        cur.execute(sql, [image_name] * 8)
        rows = cur.fetchall()

    if not rows:
        raise AssertionError(
            f"No DB row found in signalo_db.vl_official_sign for image {image_name!r}."
        )
    if len(rows) > 1:
        raise AssertionError(
            f"Image {image_name!r} matches more than one DB row; "
            "expected exactly one usage."
        )

    img_width, img_height = rows[0]
    return (float(img_width), float(img_height))


@pytest.mark.parametrize("img_dir", ["editable", "original"])
def test_official_sign_images_match_db(pg_conn, img_dir: str):
    base_dir = _images_dir(img_dir)
    assert base_dir.is_dir(), f"Missing images directory: {base_dir}"

    errors: list[str] = []

    languages = ("de", "fr", "it", "ro")

    # 1) For every sign and language: referenced images exist.
    for lang in languages:
        with pg_conn.cursor(row_factory=psycopg.rows.dict_row) as cur:
            cur.execute(
                f"SELECT id, img_{lang} AS img, img_{lang}_right AS img_right, directional_sign "
                "FROM signalo_db.vl_official_sign"
            )
            rows = cur.fetchall()

        for row in rows:
            fid = row["id"]
            img = row["img"]
            img_right = row["img_right"]
            directional = row["directional_sign"]

            if directional:
                if not img_right:
                    errors.append(
                        f"For sign {fid!r}, img_{lang}_right should be specified since it's directional."
                    )
                images = [img, img_right]
            else:
                images = [img]

            for image_name in images:
                if not image_name:
                    errors.append(f"For sign {fid!r}, img_{lang} is empty or NULL.")
                    continue

                image_path = base_dir / str(image_name)
                if not image_path.is_file():
                    errors.append(
                        f"Image {image_name!r} (id:{fid}) does not exist in {base_dir}"
                    )

    # 2) For every SVG file in the directory: it is referenced exactly once.
    for svg_path in sorted(base_dir.glob("*.svg")):
        image_name = svg_path.name
        count = _count_usage(pg_conn, image_name)
        if count != 1:
            errors.append(
                f"Image {image_name!r} is not used exactly once in signalo_db.vl_official_sign "
                f"(count={count})."
            )
            continue

        # 3) For editable SVGs: check aspect ratio vs DB img_width/img_height.
        if img_dir == "editable":
            try:
                svg_w, svg_h = svg_size_px(svg_path)
            except Exception as exc:
                errors.append(f"Cannot parse size for {image_name!r}: {exc}")
                continue

            try:
                db_w, db_h = _get_expected_size(pg_conn, image_name)
            except Exception as exc:
                errors.append(str(exc))
                continue

            if svg_w <= 0 or svg_h <= 0 or db_w <= 0 or db_h <= 0:
                errors.append(
                    f"Non-positive size for {image_name!r}: db=({db_w},{db_h}) svg=({svg_w},{svg_h})"
                )
                continue

            ir = svg_h / svg_w
            tr = db_h / db_w
            d = tr - ir

            # Mirrors the shell script: fail if d^2 > 0.01 (i.e. |d| > 0.1)
            if (d * d) > 0.01:
                errors.append(
                    "Size mismatch "
                    f"{image_name} db=({db_w},{db_h}) svg=({svg_w},{svg_h}) "
                    f"ratios: svg={ir:.6f} db={tr:.6f} d={d:.6f}"
                )

    assert not errors, "\n".join(errors)
