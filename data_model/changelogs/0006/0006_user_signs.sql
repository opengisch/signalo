--Add to signalo_db.sign a field named fk_user_sign
ALTER TABLE signalo_db.sign 
    ADD column fk_user_sign text;
;

-- Add the new sign type 'user defined' to the value list signalo_db.vl_sign_type
INSERT INTO signalo_db.vl_sign_type (id, active, value_de, value_fr) VALUES (15, true, 'benutzerdefiniert', 'défini par l''utilisateur');

-- Create the empty value list for user defined signs (same fields as vl_official_sign)
CREATE TABLE signalo_db.vl_user_sign ( 
    id text NOT NULL,
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
    default_inscription4 text
);

-- Set primary key constraint in signalo_db.vl_user_sign
ALTER TABLE ONLY signalo_db.vl_user_sign
    ADD CONSTRAINT user_sign_pkey PRIMARY KEY (id);

-- Set foreign key for user signs in signalo_db.sign
ALTER TABLE ONLY signalo_db.sign
    ADD CONSTRAINT fkey_vl_user_sign FOREIGN KEY (fk_user_sign) REFERENCES signalo_db.vl_user_sign(id) MATCH FULL;

