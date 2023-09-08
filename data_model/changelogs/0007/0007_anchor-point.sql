CREATE TYPE signalo_db.anchor_point AS ENUM ('LEFT', 'CENTER', 'RIGHT');
CREATE TYPE signalo_db.sign_hanging AS ENUM ('RECTO', 'RECTO-VERSO', 'VERSO');

ALTER TABLE signalo_db.support ADD COLUMN ordering_by_anchor_point BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE signalo_db.frame ADD COLUMN anchor_point signalo_db.anchor_point  NOT NULL DEFAULT 'CENTER'::signalo_db.anchor_point;

INSERT INTO signalo_db.vl_support_type (id, value_fr, value_de) VALUES (17, 'borne d''îlot', 'Inselpfosten');

ALTER TABLE signalo_db.sign DROP CONSTRAINT sign_fk_frame_rank_verso_key;
ALTER TABLE signalo_db.sign ADD COLUMN natural_direction_or_left BOOL NOT NULL default TRUE;
ALTER TABLE signalo_db.sign ADD COLUMN hanging_mode signalo_db.sign_hanging NOT NULL DEFAULT 'RECTO'::signalo_db.sign_hanging;
UPDATE signalo_db.sign SET hanging_mode = 'VERSO' WHERE verso IS TRUE;
ALTER TABLE signalo_db.sign DROP COLUMN verso;
ALTER TABLE signalo_db.sign ADD CONSTRAINT sign_fk_frame_rank_verso_key UNIQUE (fk_frame, rank, hanging_mode) DEFERRABLE INITIALLY DEFERRED;

-- add columns for right direction, left is default
ALTER TABLE signalo_db.vl_official_sign ADD COLUMN directional_sign BOOL NOT NULL default FALSE;
ALTER TABLE signalo_db.vl_official_sign ADD COLUMN img_de_right TEXT;
ALTER TABLE signalo_db.vl_official_sign ADD COLUMN img_fr_right TEXT;
ALTER TABLE signalo_db.vl_official_sign ADD COLUMN img_it_right TEXT;
ALTER TABLE signalo_db.vl_official_sign ADD COLUMN img_ro_right TEXT;

ALTER TABLE signalo_db.vl_official_sign ADD CONSTRAINT directional CHECK (
    directional_sign IS FALSE
    OR
    (img_de_right IS NOT NULL AND img_fr_right IS NOT NULL AND img_it_right IS NOT NULL AND img_ro_right IS NOT NULL)
);

-- adjust frame anchor point based on official sign
UPDATE signalo_db.frame f SET anchor_point = 'LEFT'::signalo_db.anchor_point
FROM signalo_db.sign s, signalo_db.vl_official_sign o
WHERE s.fk_frame = f.id AND s.fk_sign_type = 11 AND s.fk_official_sign = o.id AND o.id LIKE '%-r';

UPDATE signalo_db.frame f SET anchor_point = 'RIGHT'::signalo_db.anchor_point
FROM signalo_db.sign s, signalo_db.vl_official_sign o
WHERE s.fk_frame = f.id AND s.fk_sign_type = 11 AND s.fk_official_sign = o.id AND o.id LIKE '%-l';

UPDATE signalo_db.frame f SET anchor_point = 'CENTER'::signalo_db.anchor_point
FROM signalo_db.sign s, signalo_db.vl_official_sign o
WHERE s.fk_frame = f.id AND s.fk_sign_type = 11 AND s.fk_official_sign = o.id AND o.id NOT LIKE '%-r' AND o.id NOT LIKE '%-l';


-- adjust offical list by regrouping left + right signs
ALTER TABLE signalo_db.sign DROP CONSTRAINT fkey_vl_official_sign;

UPDATE signalo_db.vl_official_sign s1 SET
  id = replace(s1.id, '-l', '')
  , directional_sign = TRUE
  , img_de_right = s2.img_de
  , img_fr_right = s2.img_fr
  , img_it_right = s2.img_it
  , img_ro_right = s2.img_ro
FROM signalo_db.vl_official_sign s2
WHERE s1.id LIKE '%-l' AND s2.id = replace(s1.id, '-l', '-r');
DELETE FROM signalo_db.vl_official_sign WHERE id LIKE '%-r';

UPDATE signalo_db.vl_official_sign SET
    value_de = replace(value_de, ', Pfeil links', '')
    , value_fr = replace(replace(value_fr, ', flèche à gauche', ''), ' (gauche)', '')
    , value_it = replace(value_it, ', flèche à gauche', '');

UPDATE signalo_db.sign SET fk_official_sign = replace(fk_official_sign, '-l', '') WHERE fk_official_sign LIKE '%-l';
UPDATE signalo_db.sign SET fk_official_sign = replace(fk_official_sign, '-r', '') WHERE fk_official_sign LIKE '%-r';

ALTER TABLE signalo_db.sign ADD CONSTRAINT fkey_vl_official_sign FOREIGN KEY (fk_official_sign) REFERENCES signalo_db.vl_official_sign (id);
