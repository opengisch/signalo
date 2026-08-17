UPDATE signalo_db.sign
	SET id='4.50.1-1'
	WHERE id='4.50.1';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.50.1';

UPDATE signalo_db.sign
	SET id='4.50.3-1'
	WHERE id='4.50.3';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.50.3';

UPDATE signalo_db.sign
	SET id='4.50.4-1'
	WHERE id='4.50.4';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.50.4';

UPDATE signalo_db.sign
	SET id='4.50.5-vel'
	WHERE id='4.50.5';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.50.5';

UPDATE signalo_db.sign
	SET id='4.51.1-vel'
	WHERE id='4.51.1';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.51.1';

UPDATE signalo_db.sign
	SET id='4.51.2-vel'
	WHERE id='4.51.2';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.51.2';

UPDATE signalo_db.sign
	SET id='4.51.3-vel'
	WHERE id='4.51.3';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.51.3';

---- alter existing in vl_official_sign
ALTER TABLE ONLY signalo_db.sign
    DROP CONSTRAINT fkey_vl_official_sign;

UPDATE signalo_db.vl_official_sign
	SET id='4.51.3-vel-old'
	WHERE id='4.51.1-a';

UPDATE signalo_db.sign
	SET id='4.51.3-vel-old'
	WHERE id='4.51.1-a';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.51.1-a';

UPDATE signalo_db.vl_official_sign
	SET id='4.51.3-mtb-old'
	WHERE id='4.51.1-b';

UPDATE signalo_db.sign
	SET id='4.51.3-mtb-old'
	WHERE id='4.51.1-b';

DELETE FROM signalo_db.vl_official_sign
	WHERE id='4.51.1-b';

ALTER TABLE ONLY signalo_db.sign
    ADD CONSTRAINT fkey_vl_official_sign FOREIGN KEY (fk_official_sign) REFERENCES signalo_db.vl_official_sign(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;

----