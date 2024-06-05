--Add to signalo_db.sign a field named fk_balise
ALTER TABLE signalo_db.sign
    ADD column fk_balise text;

-- Add the new sign type 'balise' to the value list signalo_db.vl_sign_type
INSERT INTO signalo_db.vl_sign_type (id, active, value_de, value_fr) VALUES (16, true, 'Leiteinrichtung', 'dispositif de balisage');

-- Create the empty value list for user defined signs (same fields as vl_official_sign)
CREATE TABLE signalo_db.vl_balise (
    id text,
    active boolean DEFAULT true,
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
    img_ro_right text
);

-- Set primary key constraint in signalo_db.vl_user_sign
ALTER TABLE ONLY signalo_db.vl_balise
    ADD CONSTRAINT balise_pkey PRIMARY KEY (id);

-- Set foreign key for user signs in signalo_db.sign
ALTER TABLE ONLY signalo_db.sign
    ADD CONSTRAINT fkey_vl_balise FOREIGN KEY (fk_balise) REFERENCES signalo_db.vl_balise(id) MATCH FULL;

INSERT INTO signalo_db.vl_balise (
    id, value_de, value_fr, img_de, img_fr, img_it, img_ro, img_height, img_width, directional_sign, img_de_right, img_fr_right, img_it_right, img_ro_right)
    VALUES
   ('bal-01', 'Einfacher Markierungspfeil', 'Flèche de balisage simple', 'bal-01-l.svg', 'bal-01-l.svg', 'bal-01-l.svg', 'bal-01-l.svg', 100, 100, true, 'bal-01-r.svg', 'bal-01-r.svg', 'bal-01-r.svg', 'bal-01-r.svg'),
   ('bal-02', 'Mehrfacher Markierungspfeil', 'Flèche de balisage multiple', 'bal-02-l.svg', 'bal-02-l.svg', 'bal-02-l.svg', 'bal-02-l.svg', 50, 200, true, 'bal-02-r.svg', 'bal-02-r.svg','bal-02-r.svg', 'bal-02-r.svg'),
   ('bal-03', 'Verkehrsteiler vom Typ B', 'Séparateur de trafic de type B', 'bal-03.svg', 'bal-03.svg', 'bal-03.svg', 'bal-03.svg', 50, 200, false, NULL, NULL, NULL, NULL),
   ('bal-04', 'Leitmarkierung (Richtung)', 'Balise de guidage (direction)', 'bal-04-l.svg', 'bal-04-l.svg', 'bal-04-l.svg', 'bal-04-l.svg', 200, 50, true, 'bal-04-r.svg', 'bal-04-r.svg','bal-04-r.svg', 'bal-04-r.svg'),
   ('bal-05', 'Leitmarkierung mittig', 'Balisage de guidage milieu', 'bal-05.svg', 'bal-05.svg', 'bal-05.svg', 'bal-05.svg', 200, 50, false, NULL, NULL, NULL, NULL),
   ('bal-06', 'Leitstreifen', 'Bande de balisage', 'bal-06.svg', 'bal-06.svg', 'bal-06.svg', 'bal-06.svg', 16, 200, false, NULL, NULL, NULL, NULL);
