-- Anchors
CREATE TABLE IF NOT EXISTS signalo_db.vl_anchor
(
    id text NOT NULL,
    active boolean DEFAULT true,
    value_fr text,
    value_de text,
    description_fr text,
    description_de text,
    CONSTRAINT anchor_pkey PRIMARY KEY (id)
);

INSERT INTO signalo_db.vl_anchor (id, value_fr, value_de) VALUES ('left', 'gauche', 'links');
INSERT INTO signalo_db.vl_anchor (id, value_fr, value_de) VALUES ('center', 'centre', 'Mitte');
INSERT INTO signalo_db.vl_anchor (id, value_fr, value_de) VALUES ('right', 'droite', 'rechts');

ALTER TABLE signalo_db.frame ALTER COLUMN anchor SET DATA TYPE text USING lower(anchor::text);
ALTER TABLE signalo_db.frame ALTER COLUMN anchor SET DEFAULT 'center';
ALTER TABLE signalo_db.frame RENAME COLUMN anchor TO fk_anchor;
ALTER TABLE signalo_db.frame ADD CONSTRAINT frame_fk_anchor_key FOREIGN KEY (fk_anchor) REFERENCES signalo_db.vl_anchor (id);


-- Hanging modes
CREATE TABLE IF NOT EXISTS signalo_db.vl_hanging_mode
(
    id text,
    active boolean DEFAULT true,
    value_fr text,
    value_de text,
    description_fr text,
    description_de text,
    CONSTRAINT hanging_mode_pkey PRIMARY KEY (id)
);

INSERT INTO signalo_db.vl_hanging_mode (id, value_fr, value_de) VALUES ('recto', 'recto', 'Rechts');
INSERT INTO signalo_db.vl_hanging_mode (id, value_fr, value_de) VALUES ('recto-verso', 'recto-verso', 'Rechts-Verso');
INSERT INTO signalo_db.vl_hanging_mode (id, value_fr, value_de) VALUES ('verso', 'verso', 'Verso');

ALTER TABLE signalo_db.sign ALTER COLUMN hanging_mode SET DATA TYPE text USING lower(hanging_mode::text);
ALTER TABLE signalo_db.sign ALTER COLUMN hanging_mode SET DEFAULT 'recto';
ALTER TABLE signalo_db.sign RENAME COLUMN hanging_mode TO fk_hanging_mode;
ALTER TABLE signalo_db.sign ADD CONSTRAINT frame_fk_hanging_mode_key FOREIGN KEY (fk_hanging_mode) REFERENCES signalo_db.vl_hanging_mode (id);

-- clean up
DROP TYPE signalo_db.anchor;
DROP TYPE signalo_db.sign_hanging;
