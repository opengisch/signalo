
CREATE TABLE siro_od.sign
(
    id uuid PRIMARY KEY,
    fk_sign_type int NOT NULL,
    fk_official_sign int,
    fk_owner text,
    fk_durability int,
    fk_status int,
    installation_date date,
    case_id text,
    case_decision text,
    -- date_repose
    fk_coating int,
    fk_lighting int,
    destination text,
    azimut smallint,
    comment text
    photo text,
    CONSTRAINT fkey_vl_sign_type FOREIGN KEY (fk_type) REFERENCES siro_vl.sign_type (id) MATCH SIMPLE,
    CONSTRAINT fkey_vl_official_sign FOREIGN KEY (fk_official) REFERENCES siro_vl.official_sign (id) MATCH SIMPLE,
    CONSTRAINT fkey_od_owner FOREIGN KEY (fk_owner) REFERENCES siro_od.owner (id) MATCH SIMPLE,
    CONSTRAINT fkey_vl_durability FOREIGN KEY (fk_durability) REFERENCES siro_vl.durability (id) MATCH SIMPLE,
    CONSTRAINT fkey_vl_coating FOREIGN KEY (fk_coating) REFERENCES siro_vl.coating (id) MATCH SIMPLE,
    CONSTRAINT fkey_vl_lighting FOREIGN KEY (fk_lighting) REFERENCES siro_vl.lighting (id) MATCH SIMPLE,
    CONSTRAINT fkey_vl_status FOREIGN KEY (fk_status) REFERENCES siro_vl.status (id) MATCH SIMPLE,
);