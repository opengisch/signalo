-- add missing dimensions

UPDATE signalo_db.vl_official_sign
SET img_height = 100,
    img_width = 65 WHERE id = '4.51.3';
