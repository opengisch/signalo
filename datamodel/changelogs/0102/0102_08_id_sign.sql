ALTER TABLE ONLY signalo_db.sign
    DROP CONSTRAINT fkey_vl_official_sign;

UPDATE signalo_db.vl_official_sign
    SET id = '4.77/11-2',
    img_de = '477-11-2.svg',
    img_fr = '477-11-2.svg',
    img_it = '477-11-2.svg',
    img_ro = '477-11-2.svg'
      WHERE id = '4.77/1-01';

UPDATE signalo_db.vl_official_sign
    SET id = '4.77/11-1',
    img_de = '477-11-1.svg',
    img_fr = '477-11-1.svg',
    img_it = '477-11-1.svg',
    img_ro = '477-11-1.svg'
      WHERE id = '4.77/11';

UPDATE signalo_db.sign
SET fk_official_sign = '4.77/11-1' where fk_official_sign = '4.77/11';

UPDATE signalo_db.sign
SET fk_official_sign = '4.77/11-2' where fk_official_sign = '4.77/1-01';


ALTER TABLE ONLY signalo_db.sign
    ADD CONSTRAINT fkey_vl_official_sign FOREIGN KEY (fkey_vl_official_sign) REFERENCES signalo_db.vl_official_sign(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;
