-- add columns for right direction, left is default
ALTER TABLE signalo_db.vl_user_sign ADD COLUMN directional_sign BOOL NOT NULL default FALSE;

ALTER TABLE signalo_db.vl_user_sign ADD COLUMN img_de_right TEXT;
ALTER TABLE signalo_db.vl_user_sign ADD COLUMN img_fr_right TEXT;
ALTER TABLE signalo_db.vl_user_sign ADD COLUMN img_it_right TEXT;
ALTER TABLE signalo_db.vl_user_sign ADD COLUMN img_ro_right TEXT;

ALTER TABLE signalo_db.vl_user_sign ADD CONSTRAINT directional CHECK (
    directional_sign IS FALSE
    OR
    (img_de_right IS NOT NULL AND img_fr_right IS NOT NULL AND img_it_right IS NOT NULL AND img_ro_right IS NOT NULL)
);