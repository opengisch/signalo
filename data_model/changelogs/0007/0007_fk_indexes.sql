CREATE INDEX sign_fk_frame_idx ON signalo_db.sign (fk_frame);
CREATE INDEX frame_fk_azimut_idx ON signalo_db.frame (fk_azimut);
CREATE INDEX azimut_fk_support_idx ON signalo_db.azimut (fk_support);
