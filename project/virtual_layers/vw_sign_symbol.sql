-- QGIS Virtual Layer port of signalo_app.vw_sign_symbol.
--
-- Mirrors datamodel/app/vw_sign_symbol.py so the sign symbology keeps recomputing
-- when the project is taken offline in QField, where the PostgreSQL view is only a
-- frozen snapshot. Source tables are referenced by the aliases declared as
-- `layer_ref=<layerid>:<alias>` in the layer URI, so this file needs no substitution.
--
-- Differences from the PostgreSQL view, all deliberate:
--   * only the columns the symbology consumes are projected (see README.md);
--   * `_vl_fid` is added because the virtual layer provider reads the uid column as
--     int64 -- a text `pk` would collapse every feature onto fid 0;
--   * UNION ALL replaces UNION: the four branches are disjoint (grouped/not-grouped by
--     the WHERE clause, recto/verso by `_verso`), so no row can be deduplicated;
--   * `::type` casts and `false::bool` become CAST(...)/0-1, and the cosmetic
--     ORDER BY inside the branch CTEs is dropped.
-- The `*_n` CTEs exist for one reason. The virtual layer provider offers to satisfy an `=`
-- on a layer's primary key itself, then honours it with setFilterFid(sqlite3_value_int()),
-- coercing the key to an integer feature id -- so a uuid join asks for feature 0 and
-- sign->frame matched 0 of 34 rows, silently. Casting inside the ON clause blocks that
-- push-down and fixes the result, but also defeats SQLite's index use, turning every join
-- into a per-row provider lookup (a 34-sign project did not finish in 9 minutes).
-- Normalising each source once into a MATERIALIZED CTE gives both.
-- Text and integer keys (official_sign.id, marker_type.id) are unaffected, but are carried
-- through the same CTEs to keep the shape uniform.
-- Fixed upstream by QGIS 5cb8ed11a09 (master and 4.2, not 3.44): these CTEs can become
-- plain joins once the QGIS floor -- desktop and the one QField embeds -- is past 3.44.
-- `_azimut_rectified` keeps the view's asymmetry (+180 with no % 360) on purpose, so
-- the two layers stay comparable row for row.
WITH sign_n AS MATERIALIZED (
    SELECT
        CAST(id AS TEXT) AS id,
        CAST(fk_frame AS TEXT) AS fk_frame,
        CAST(fk_user_sign AS TEXT) AS fk_user_sign,
        rank, fk_hanging_mode, natural_direction_or_left, fk_sign_type, complex,
        fk_official_sign, fk_marker_type, fk_mirror_shape, mirror_red_frame,
        inscription_1, inscription_2, inscription_3
    FROM sign
),
frame_n AS MATERIALIZED (
    SELECT CAST(id AS TEXT) AS id, CAST(fk_azimut AS TEXT) AS fk_azimut, rank, fk_mounting_point
    FROM frame
),
azimut_n AS MATERIALIZED (
    SELECT CAST(id AS TEXT) AS id, CAST(fk_support AS TEXT) AS fk_support,
           azimut, offset_x, offset_y, offset_x_verso, offset_y_verso
    FROM azimut
),
support_n AS MATERIALIZED (
    SELECT CAST(id AS TEXT) AS id, geometry, group_by_mounting_point, fk_support_type
    FROM support
),
official_sign_n AS MATERIALIZED (
    SELECT CAST(id AS TEXT) AS id, directional_sign, value_fr,
           img_de, img_fr, img_it, img_ro, img_de_right, img_fr_right, img_it_right, img_ro_right,
           img_height, img_width
    FROM official_sign
),
user_sign_n AS MATERIALIZED (
    SELECT CAST(id AS TEXT) AS id, directional_sign, value_fr,
           img_de, img_fr, img_it, img_ro, img_de_right, img_fr_right, img_it_right, img_ro_right,
           img_height, img_width
    FROM user_sign
),
marker_type_n AS MATERIALIZED (
    SELECT id, directional_sign, value_fr,
           img_de, img_fr, img_it, img_ro, img_de_right, img_fr_right, img_it_right, img_ro_right,
           img_height, img_width
    FROM marker_type
),
joined_tables AS (
    SELECT
        sign.id AS id,
        sign.rank AS sign_rank,
        sign.fk_hanging_mode AS sign_fk_hanging_mode,
        sign.natural_direction_or_left AS sign_natural_direction_or_left,
        sign.fk_sign_type AS sign_fk_sign_type,
        sign.complex AS sign_complex,
        sign.fk_official_sign AS sign_fk_official_sign,
        sign.fk_user_sign AS sign_fk_user_sign,
        sign.inscription_1 AS sign_inscription_1,
        sign.inscription_2 AS sign_inscription_2,
        sign.inscription_3 AS sign_inscription_3,
        frame.id AS frame_id,
        frame.rank AS frame_rank,
        frame.fk_mounting_point AS frame_fk_mounting_point,
        azimut.id AS azimut_id,
        azimut.azimut AS azimut_azimut,
        azimut.offset_x AS azimut_offset_x,
        azimut.offset_y AS azimut_offset_y,
        azimut.offset_x_verso AS azimut_offset_x_verso,
        azimut.offset_y_verso AS azimut_offset_y_verso,
        support.id AS support_id,
        support.geometry AS support_geometry,
        support.group_by_mounting_point AS support_group_by_mounting_point,
        support.fk_support_type AS support_fk_support_type,
        COALESCE(official_sign.directional_sign, user_sign.directional_sign, marker_type.directional_sign, 0) AS directional_sign,
        CASE
            WHEN sign.fk_sign_type = 15 THEN user_sign.value_fr
            WHEN sign.fk_sign_type = 12 THEN marker_type.value_fr
            ELSE official_sign.value_fr
        END AS _symbol_value_fr,
        CASE
            WHEN sign.complex IS TRUE THEN 'complex.svg'
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_de
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_de
            WHEN sign.fk_sign_type = 13 THEN 'mirror' || CASE WHEN sign.fk_mirror_shape = 12 THEN '-circular' ELSE '' END || CASE WHEN NOT sign.mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'
            WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_de
            ELSE NULL
        END AS _img_de,
        CASE
            WHEN sign.complex IS TRUE THEN 'complex.svg'
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_fr
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_fr
            WHEN sign.fk_sign_type = 13 THEN 'mirror' || CASE WHEN sign.fk_mirror_shape = 12 THEN '-circular' ELSE '' END || CASE WHEN NOT sign.mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'
            WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_fr
            ELSE NULL
        END AS _img_fr,
        CASE
            WHEN sign.complex IS TRUE THEN 'complex.svg'
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_it
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_it
            WHEN sign.fk_sign_type = 13 THEN 'mirror' || CASE WHEN sign.fk_mirror_shape = 12 THEN '-circular' ELSE '' END || CASE WHEN NOT sign.mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'
            WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_it
            ELSE NULL
        END AS _img_it,
        CASE
            WHEN sign.complex IS TRUE THEN 'complex.svg'
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_ro
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_ro
            WHEN sign.fk_sign_type = 13 THEN 'mirror' || CASE WHEN sign.fk_mirror_shape = 12 THEN '-circular' ELSE '' END || CASE WHEN NOT sign.mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'
            WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_ro
            ELSE NULL
        END AS _img_ro,
        CASE
            WHEN sign.complex IS TRUE THEN 'complex.svg'
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_de_right
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_de_right
            WHEN sign.fk_sign_type = 13 THEN 'mirror' || CASE WHEN sign.fk_mirror_shape = 12 THEN '-circular' ELSE '' END || CASE WHEN NOT sign.mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'
            WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_de_right
            ELSE NULL
        END AS _img_de_right,
        CASE
            WHEN sign.complex IS TRUE THEN 'complex.svg'
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_fr_right
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_fr_right
            WHEN sign.fk_sign_type = 13 THEN 'mirror' || CASE WHEN sign.fk_mirror_shape = 12 THEN '-circular' ELSE '' END || CASE WHEN NOT sign.mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'
            WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_fr_right
            ELSE NULL
        END AS _img_fr_right,
        CASE
            WHEN sign.complex IS TRUE THEN 'complex.svg'
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_it_right
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_it_right
            WHEN sign.fk_sign_type = 13 THEN 'mirror' || CASE WHEN sign.fk_mirror_shape = 12 THEN '-circular' ELSE '' END || CASE WHEN NOT sign.mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'
            WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_it_right
            ELSE NULL
        END AS _img_it_right,
        CASE
            WHEN sign.complex IS TRUE THEN 'complex.svg'
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_ro_right
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_ro_right
            WHEN sign.fk_sign_type = 13 THEN 'mirror' || CASE WHEN sign.fk_mirror_shape = 12 THEN '-circular' ELSE '' END || CASE WHEN NOT sign.mirror_red_frame THEN '-noframe' ELSE '' END || '.svg'
            WHEN sign.fk_sign_type = 14 THEN 'street-plate.svg'
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_ro_right
            ELSE NULL
        END AS _img_ro_right,
        CASE
            WHEN sign.complex IS TRUE THEN 106
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_height
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_height
            WHEN sign.fk_sign_type = 13 THEN 80
            WHEN sign.fk_sign_type = 14 THEN 50
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_height
            ELSE NULL
        END AS _symbol_height,
        CASE
            WHEN sign.complex IS TRUE THEN 121
            WHEN sign.fk_sign_type = 11 THEN official_sign.img_width
            WHEN sign.fk_sign_type = 12 THEN marker_type.img_width
            WHEN sign.fk_sign_type = 13 THEN 100
            WHEN sign.fk_sign_type = 14 THEN 100
            WHEN sign.fk_sign_type = 15 THEN user_sign.img_width
            ELSE NULL
        END AS _symbol_width
    FROM sign_n AS sign
    LEFT JOIN frame_n AS frame ON frame.id = sign.fk_frame
    LEFT JOIN azimut_n AS azimut ON azimut.id = frame.fk_azimut
    LEFT JOIN support_n AS support ON support.id = azimut.fk_support
    LEFT JOIN official_sign_n AS official_sign ON official_sign.id = sign.fk_official_sign
    LEFT JOIN user_sign_n AS user_sign ON user_sign.id = sign.fk_user_sign
    LEFT JOIN marker_type_n AS marker_type ON marker_type.id = sign.fk_marker_type
),
-- recto, NOT grouped by mounting point
ordered_recto_not_grouped AS (
    SELECT
        jt.*,
        jt.azimut_azimut AS _azimut_rectified,
        jt.azimut_offset_x AS _azimut_offset_x_rectified,
        jt.azimut_offset_y AS _azimut_offset_y_rectified,
        jt.sign_natural_direction_or_left AS _natural_direction_or_left_rectified,
        0 AS _verso,
        ROW_NUMBER() OVER (PARTITION BY jt.support_id, jt.azimut_azimut ORDER BY jt.frame_rank, jt.sign_rank) AS _rank
    FROM joined_tables jt
    WHERE jt.sign_fk_hanging_mode != 'verso' AND jt.support_group_by_mounting_point IS FALSE
),
-- recto, grouped by mounting point
ordered_recto_grouped AS (
    SELECT
        jt.*,
        jt.azimut_azimut AS _azimut_rectified,
        jt.azimut_offset_x AS _azimut_offset_x_rectified,
        jt.azimut_offset_y AS _azimut_offset_y_rectified,
        jt.sign_natural_direction_or_left AS _natural_direction_or_left_rectified,
        0 AS _verso,
        ROW_NUMBER() OVER (PARTITION BY jt.support_id, jt.azimut_azimut, jt.frame_fk_mounting_point ORDER BY jt.frame_rank, jt.sign_rank) AS _rank
    FROM joined_tables jt
    WHERE jt.sign_fk_hanging_mode != 'verso' AND jt.support_group_by_mounting_point IS TRUE
),
-- verso, NOT grouped by mounting point
ordered_verso_not_grouped AS (
    SELECT
        jt.*,
        jt.azimut_azimut + 180 AS _azimut_rectified,
        COALESCE(az.offset_x, jt.azimut_offset_x_verso) AS _azimut_offset_x_rectified,
        COALESCE(az.offset_y, jt.azimut_offset_y_verso) AS _azimut_offset_y_rectified,
        NOT jt.sign_natural_direction_or_left AS _natural_direction_or_left_rectified,
        1 AS _verso,
        1000 + ROW_NUMBER() OVER (PARTITION BY jt.support_id, jt.azimut_azimut ORDER BY jt.frame_rank, jt.sign_rank) AS _rank
    FROM joined_tables jt
    LEFT JOIN azimut_n az ON az.azimut = ((jt.azimut_azimut + 180) % 360) AND az.fk_support = jt.support_id
    WHERE jt.sign_fk_hanging_mode != 'recto' AND jt.support_group_by_mounting_point IS FALSE
),
-- verso, grouped by mounting point
ordered_verso_grouped AS (
    SELECT
        jt.*,
        jt.azimut_azimut + 180 AS _azimut_rectified,
        COALESCE(az.offset_x, jt.azimut_offset_x_verso) AS _azimut_offset_x_rectified,
        COALESCE(az.offset_y, jt.azimut_offset_y_verso) AS _azimut_offset_y_rectified,
        NOT jt.sign_natural_direction_or_left AS _natural_direction_or_left_rectified,
        1 AS _verso,
        1000 + ROW_NUMBER() OVER (PARTITION BY jt.support_id, jt.azimut_azimut, jt.frame_fk_mounting_point ORDER BY jt.frame_rank, jt.sign_rank) AS _rank
    FROM joined_tables jt
    LEFT JOIN azimut_n az ON az.azimut = ((jt.azimut_azimut + 180) % 360) AND az.fk_support = jt.support_id
    WHERE jt.sign_fk_hanging_mode != 'recto' AND jt.support_group_by_mounting_point IS TRUE
),
ordered_not_grouped AS (
    SELECT * FROM ordered_recto_not_grouped
    UNION ALL
    SELECT * FROM ordered_verso_not_grouped
),
ordered_grouped AS (
    SELECT * FROM ordered_recto_grouped
    UNION ALL
    SELECT * FROM ordered_verso_grouped
),
shifted_not_grouped AS (
    SELECT
        o.*,
        ROW_NUMBER() OVER (PARTITION BY o.support_id, o._azimut_rectified ORDER BY o._rank) AS _final_rank,
        COALESCE(SUM(o._symbol_height) OVER (PARTITION BY o.support_id, o._azimut_rectified ORDER BY o._rank ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS _symbol_shift,
        COALESCE(SUM(o._symbol_height) OVER (PARTITION BY o.support_id, o._azimut_rectified), 0) AS _group_height,
        MAX(o._symbol_width) OVER (PARTITION BY o.support_id, o._azimut_rectified) AS _group_width
    FROM ordered_not_grouped o
),
shifted_grouped AS (
    SELECT
        o.*,
        ROW_NUMBER() OVER (PARTITION BY o.support_id, o._azimut_rectified, o.frame_fk_mounting_point ORDER BY o._rank) AS _final_rank,
        COALESCE(SUM(o._symbol_height) OVER (PARTITION BY o.support_id, o._azimut_rectified, o.frame_fk_mounting_point ORDER BY o._rank ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS _symbol_shift,
        COALESCE(SUM(o._symbol_height) OVER (PARTITION BY o.support_id, o._azimut_rectified, o.frame_fk_mounting_point), 0) AS _group_height,
        MAX(o._symbol_width) OVER (PARTITION BY o.support_id, o._azimut_rectified, o.frame_fk_mounting_point) AS _group_width
    FROM ordered_grouped o
),
union_view AS (
    SELECT * FROM shifted_not_grouped
    UNION ALL
    SELECT * FROM shifted_grouped
),
final AS (
    SELECT
        uv.*,
        uv.id || '-' || CAST(uv._verso AS INTEGER) AS pk,
        MAX(uv._group_height) OVER (PARTITION BY uv.support_id, uv.azimut_azimut, uv._verso) AS _max_shift_for_azimut,
        CASE
            WHEN uv.directional_sign IS TRUE AND (uv.frame_fk_mounting_point, uv._natural_direction_or_left_rectified) IN (
                ('left', 1),
                ('center', 0),
                ('right', 0)
            ) THEN '_right'
            ELSE ''
        END AS _img_direction
    FROM union_view uv
)
SELECT
    ROW_NUMBER() OVER (ORDER BY id, _verso) AS _vl_fid,
    pk,
    support_geometry,
    sign_inscription_1,
    sign_inscription_2,
    sign_inscription_3,
    sign_fk_sign_type,
    sign_fk_hanging_mode,
    sign_complex,
    sign_fk_official_sign,
    sign_fk_user_sign,
    frame_fk_mounting_point,
    support_fk_support_type,
    directional_sign,
    _symbol_value_fr,
    _img_direction,
    _img_de,
    _img_fr,
    _img_it,
    _img_ro,
    _img_de_right,
    _img_fr_right,
    _img_it_right,
    _img_ro_right,
    _azimut_rectified,
    _azimut_offset_x_rectified,
    _azimut_offset_y_rectified,
    _symbol_height,
    _symbol_width,
    _verso,
    _final_rank,
    _symbol_shift,
    _group_width,
    _max_shift_for_azimut
FROM final
