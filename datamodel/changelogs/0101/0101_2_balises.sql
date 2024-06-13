--Add to signalo_db.sign a field named fk_balise
ALTER TABLE signalo_db.sign
    DROP CONSTRAINT fkey_vl_marker_type;

DROP TABLE IF EXISTS signalo_db.vl_marker_type;

CREATE TABLE signalo_db.vl_marker_type (
	id text,
	active boolean,
	value_de text,
    value_fr text,
	value_it text,
    value_ro text,
	description_de text,
	description_fr text,
    description_it text,
    description_ro text,
    img_de text,
    img_fr text,
    img_it text,
    img_ro text,
    img_height integer DEFAULT 100,
    img_width integer DEFAULT 100,
    no_dynamic_inscription integer DEFAULT 0,
    default_inscription1 text,
    default_inscription2 text,
    default_inscription3 text,
    default_inscription4 text,
    directional_sign boolean,
    img_de_right text,
    img_fr_right text,
    img_it_right text,
    img_ro_right text);

ALTER TABLE signalo_db.sign
    ALTER COLUMN fk_marker_type TYPE text USING fk_marker_type::text;

INSERT INTO signalo_db.vl_marker_type (
    id, active, value_de, value_fr, img_de, img_fr, img_it, img_ro, img_height, img_width, directional_sign, img_de_right, img_fr_right, img_it_right, img_ro_right)
    VALUES
    ('m-1', true, 'unbekannt', 'inconnu', NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL),
    ('m-2', true, 'andere', 'autre', NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL),
    ('m-3', true, 'zu bestimmen', 'à déterminer', NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL),
    ('m-11', true, 'Einfacher Leitpfeil', 'Flèche de balisage simple', 'm-11-l.svg', 'm-11-l.svg', 'm-11-l.svg', 'm-11-l.svg', 100, 100, true, 'm-11-r.svg', 'm-11-r.svg', 'm-11-r.svg', 'm-11-r.svg'),
    ('m-12', true, 'Mehrfacher Leitpfeil', 'Flèche de balisage multiple', 'm-12-l.svg', 'm-12-l.svg', 'm-12-l.svg', 'm-12-l.svg', 50, 200, true, 'm-12-r.svg', 'm-12-r.svg','m-12-r.svg', 'm-12-r.svg'),
    ('m-13', true, 'Verkehrsteiler vom Typ B', 'Séparateur de trafic de type B', 'm-13.svg', 'm-13.svg', 'm-13.svg', 'm-13.svg', 50, 200, false, NULL, NULL, NULL, NULL),
    ('m-14', true, 'Leitbake (Richtung)', 'Balise de guidage (direction)', 'm-14-l.svg', 'm-14-l.svg', 'm-14-l.svg', 'm-14-l.svg', 200, 50, true, 'm-14-r.svg', 'm-14-r.svg','m-14-r.svg', 'm-14-r.svg'),
    ('m-15', true, 'Leitbake mittig', 'Balisage de guidage milieu', 'm-15.svg', 'm-15.svg', 'm-15.svg', 'm-15.svg', 200, 50, false, NULL, NULL, NULL, NULL),
    ('m-16', true, 'Leitstreifen', 'Bande de balisage', 'm-16.svg', 'm-16.svg', 'm-16.svg', 'm-16.svg', 16, 200, false, NULL, NULL, NULL, NULL);

UPDATE signalo_db.sign
SET fk_marker_type = 'm-1'
WHERE fk_marker_type = '1';

UPDATE signalo_db.sign
SET fk_marker_type = 'm-2'
WHERE fk_marker_type = '2';

UPDATE signalo_db.sign
SET fk_marker_type = 'm-3'
WHERE fk_marker_type = '3';

-- If former type was just "balise"
UPDATE signalo_db.sign
SET fk_marker_type = 'm-3'
WHERE fk_marker_type = '11';

UPDATE signalo_db.sign
SET fk_marker_type = 'm-11'
WHERE fk_marker_type = '12';

UPDATE signalo_db.sign
SET fk_marker_type = 'm-16'
WHERE fk_marker_type = '13';

UPDATE signalo_db.sign
SET fk_marker_type = 'm-14'
WHERE fk_marker_type = '14';

-- If former type was in fact referencing a support type, not a marker-sign (borne d'îlot)
UPDATE signalo_db.sign
SET fk_marker_type = 'm-3'
WHERE fk_marker_type = '15';

UPDATE signalo_db.sign
SET fk_marker_type = 'm-13'
WHERE fk_marker_type = '16';

-- Set primary key constraint in signalo_db.vl_marker_type
ALTER TABLE ONLY signalo_db.vl_marker_type
    ADD CONSTRAINT marker_type_pkey PRIMARY KEY (id);

-- Set foreign key for user signs in signalo_db.sign
ALTER TABLE ONLY signalo_db.sign
    ADD CONSTRAINT fkey_vl_marker_type FOREIGN KEY (fk_marker_type) REFERENCES signalo_db.vl_marker_type(id) MATCH FULL;

-- Recreate functions and triggers in signalo_db.sign
-- FUNCTION: signalo_db.ft_reorder_signs_in_frame()
CREATE OR REPLACE FUNCTION signalo_db.ft_reorder_signs_in_frame()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	DECLARE
	    _rank integer := 1;
	    _sign record;
	BEGIN
        FOR _sign IN (SELECT * FROM signalo_db.sign WHERE fk_frame = OLD.fk_frame ORDER BY rank ASC)
        LOOP
            UPDATE signalo_db.sign SET rank = _rank WHERE id = _sign.id;
            _rank = _rank + 1;
        END LOOP;
		RETURN OLD;
	END;

$BODY$;

ALTER FUNCTION signalo_db.ft_reorder_signs_in_frame()
    OWNER TO postgres;


-- FUNCTION: signalo_db.ft_sign_prevent_fk_frame_update()

CREATE OR REPLACE FUNCTION signalo_db.ft_sign_prevent_fk_frame_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
    BEGIN
      RAISE EXCEPTION 'A sign cannot be reassigned to another frame.';
    END;

$BODY$;

ALTER FUNCTION signalo_db.ft_sign_prevent_fk_frame_update()
    OWNER TO postgres;


-- Set trigger: tr_sign_on_delete_reorder
CREATE OR REPLACE TRIGGER tr_sign_on_delete_reorder
    AFTER DELETE
    ON signalo_db.sign
    FOR EACH ROW
    EXECUTE FUNCTION signalo_db.ft_reorder_signs_in_frame();

COMMENT ON TRIGGER tr_sign_on_delete_reorder ON signalo_db.sign
    IS 'Trigger: update signs order after deleting one.';

-- Set trigger: tr_sign_on_update_prevent_fk_frame
CREATE OR REPLACE TRIGGER tr_sign_on_update_prevent_fk_frame
    BEFORE UPDATE OF fk_frame
    ON signalo_db.sign
    FOR EACH ROW
    WHEN (new.fk_frame <> old.fk_frame)
    EXECUTE FUNCTION signalo_db.ft_sign_prevent_fk_frame_update();
