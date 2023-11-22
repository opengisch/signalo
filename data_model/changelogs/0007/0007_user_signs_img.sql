/* ALTER TABLE signalo_db.vl_user_sign
    ADD column img text,
    ADD column value text;

UPDATE signalo_db.vl_user_sign set img = coalesce(img_fr, img_de, img_it, img_ro, NULL);
UPDATE signalo_db.vl_user_sign set value = coalesce(value_fr, value_de, value_it, value_ro, NULL);

ALTER TABLE signalo_db.vl_user_sign
    DROP column img_fr,
    DROP column value_fr,
    DROP column img_de,
    DROP column value_de,
    DROP column img_it,
    DROP column value_it,
    DROP column img_ro,
    DROP column value_ro;
*/