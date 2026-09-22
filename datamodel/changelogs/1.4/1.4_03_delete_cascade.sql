-- Fix: deleting a pre-existing frame (cadre) from QField blocked the whole
-- QFieldSync import because sign.fk_frame had no ON DELETE action, so the
-- delete raised "violates foreign key constraint fkey_od_frame" and the
-- import transaction was rolled back.
-- The QGIS project defines the support -> azimut -> frame -> sign relations
-- as Composition, so the database mirrors this with ON DELETE CASCADE.

ALTER TABLE signalo_db.sign
    DROP CONSTRAINT fkey_od_frame,
    ADD CONSTRAINT fkey_od_frame FOREIGN KEY (fk_frame) REFERENCES signalo_db.frame(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE signalo_db.frame
    DROP CONSTRAINT fkey_od_azimut,
    ADD CONSTRAINT fkey_od_azimut FOREIGN KEY (fk_azimut) REFERENCES signalo_db.azimut(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE signalo_db.azimut
    DROP CONSTRAINT fkey_od_support,
    ADD CONSTRAINT fkey_od_support FOREIGN KEY (fk_support) REFERENCES signalo_db.support(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;
