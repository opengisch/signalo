-- Table: siro.shelf

-- DROP TABLE siro.shelf;

CREATE TABLE siro.shelf
(
    id serial PRIMARY KEY,
    adress text COLLATE pg_catalog."default",
    adress_no abstime,
    adress_additional text COLLATE pg_catalog."default",
    type_shelf integer,
    owner integer,
    type_base integer,
    height numeric(8,3),
    height_free_under_signal numeric(8,3),
    date_install date,
    date_last_stability_check date,
    state integer,
    comment text COLLATE pg_catalog."default",
    picture text COLLATE pg_catalog."default",
    geometry geometry(Point,2056) NOT NULL,
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE siro.shelf
    OWNER to postgres;