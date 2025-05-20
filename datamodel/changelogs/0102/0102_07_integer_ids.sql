ALTER TABLE ONLY signalo_db.sign
    DROP CONSTRAINT fkey_vl_marker_type;

ALTER TABLE signalo_db.vl_marker_type
    ALTER COLUMN id TYPE SMALLINT USING (replace(id, 'm-', '')::SMALLINT),
    ALTER COLUMN id SET DEFAULT 1;


ALTER TABLE signalo_db.sign
    ALTER COLUMN fk_marker_type TYPE SMALLINT USING (replace(fk_marker_type, 'm-', '')::SMALLINT);

ALTER TABLE ONLY signalo_db.sign
    ADD CONSTRAINT fkey_vl_marker_type FOREIGN KEY (fk_marker_type) REFERENCES signalo_db.vl_marker_type(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;
