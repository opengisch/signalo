-- Table: siro_od.support

-- DROP TABLE siro_od.support;

CREATE TABLE siro_od.support
(
    id uuid PRIMARY KEY,
    adress text,
    fk_support_type integer,
    fk_owner text,
    fk_type_base integer,
    height numeric(8,3),
    height_free_under_signal numeric(8,3),
    date_install date,
    date_last_stability_check date,
    state integer,
    comment text,
    picture text,
    geometry geometry(Point,2056) NOT NULL,
    CONSTRAINT fkey_vl_support_type FOREIGN KEY (fk_support_type) REFERENCES siro_vl.support_type (id) MATCH SIMPLE,
    CONSTRAINT fkey_od_owner FOREIGN KEY (fk_owner) REFERENCES siro_od.owner (id) MATCH SIMPLE,
    CONSTRAINT fkey_type_base FOREIGN KEY (fk_type_base) REFERENCES siro_vl.type_base (id) MATCH SIMPLE
);