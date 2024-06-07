--Add to signalo_db.sign a field named fk_balise
ALTER TABLE signalo_db.sign
    DROP CONSTRAINT fkey_vl_balise,
    DROP CONSTRAINT fkey_vl_marker_type;

TRUNCATE signalo_db.vl_marker_type;

ALTER TABLE signalo_db.vl_marker_type
    DROP CONSTRAINT marker_type_pkey,
	DROP COLUMN id,
	DROP COLUMN active,
	DROP COLUMN value_de,
	DROP COLUMN value_fr,
	DROP COLUMN description_de,
	DROP COLUMN description_fr;

ALTER TABLE signalo_db.vl_marker_type
	ADD COLUMN id text,
	ADD COLUMN active boolean,
	ADD COLUMN value_de text,
    ADD COLUMN value_fr text,
	ADD COLUMN value_it text,
    ADD COLUMN value_ro text,
	ADD COLUMN description_de text,
	ADD COLUMN description_fr text,
    ADD COLUMN description_it text,
    ADD COLUMN description_ro text,
    ADD COLUMN img_de text,
    ADD COLUMN img_fr text,
    ADD COLUMN img_it text,
    ADD COLUMN img_ro text,
    ADD COLUMN img_height integer DEFAULT 100,
    ADD COLUMN img_width integer DEFAULT 100,
    ADD COLUMN no_dynamic_inscription integer DEFAULT 0,
    ADD COLUMN default_inscription1 text,
    ADD COLUMN default_inscription2 text,
    ADD COLUMN default_inscription3 text,
    ADD COLUMN default_inscription4 text,
    ADD COLUMN directional_sign boolean, 
    ADD COLUMN img_de_right text, 
    ADD COLUMN img_fr_right text, 
    ADD COLUMN img_it_right text, 
    ADD COLUMN img_ro_right text;

-- Add the new sign type 'balise' to the value list signalo_db.vl_sign_type
-- INSERT INTO signalo_db.vl_sign_type (id, active, value_de, value_fr) VALUES (16, true, 'Leiteinrichtung', 'dispositif de balisage');


ALTER TABLE signalo_db.vl_marker_type
    ALTER COLUMN id TYPE text USING id::text;

ALTER TABLE signalo_db.sign
    ALTER COLUMN fk_marker_type TYPE text USING fk_marker_type::text;

INSERT INTO signalo_db.vl_marker_type (
    id, value_de, value_fr, img_de, img_fr, img_it, img_ro, img_height, img_width, directional_sign, img_de_right, img_fr_right, img_it_right, img_ro_right)
    VALUES
    ('m-1', 'unbekannt', 'inconnu', NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL),
    ('m-2', 'andere', 'autre', NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL),
    ('m-3', 'zu bestimmen', 'à déterminer', NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL),
    ('m-11', 'Einfacher Leitpfeil', 'Flèche de balisage simple', 'm-11-l.svg', 'm-11-l.svg', 'm-11-l.svg', 'm-11-l.svg', 100, 100, true, 'm-11-r.svg', 'm-11-r.svg', 'm-11-r.svg', 'm-11-r.svg'),
    ('m-12', 'Mehrfacher Leitpfeil', 'Flèche de balisage multiple', 'm-12-l.svg', 'm-12-l.svg', 'm-12-l.svg', 'm-12-l.svg', 50, 200, true, 'm-12-r.svg', 'm-12-r.svg','m-12-r.svg', 'm-12-r.svg'),
    ('m-13', 'Verkehrsteiler vom Typ B', 'Séparateur de trafic de type B', 'm-13.svg', 'm-13.svg', 'm-13.svg', 'm-13.svg', 50, 200, false, NULL, NULL, NULL, NULL),
    ('m-14', 'Leitbake (Richtung)', 'Balise de guidage (direction)', 'm-14-l.svg', 'm-14-l.svg', 'm-14-l.svg', 'm-14-l.svg', 200, 50, true, 'm-14-r.svg', 'm-14-r.svg','m-14-r.svg', 'm-14-r.svg'),
    ('m-15', 'Leitbake mittig', 'Balisage de guidage milieu', 'm-15.svg', 'm-15.svg', 'm-15.svg', 'm-15.svg', 200, 50, false, NULL, NULL, NULL, NULL),
    ('m-16', 'Leitstreifen', 'Bande de balisage', 'm-16.svg', 'm-16.svg', 'm-16.svg', 'm-16.svg', 16, 200, false, NULL, NULL, NULL, NULL);

UPDATE signalo_db.sign
SET fk_marker_type = 'm-1'
WHERE fk_marker_type = '1';

UPDATE signalo_db.sign
SET fk_marker_type = 'm-2'
WHERE fk_marker_type = '2';

UPDATE signalo_db.sign
SET fk_marker_type = 'm-3'
WHERE fk_marker_type = '3';

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



-- error : cannot ALTER TABLE "sign" because it has pending trigger events 
