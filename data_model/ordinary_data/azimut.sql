


CREATE TABLE siro_od.azimut
(
    id uuid PRIMARY KEY default uuid_generate_v1(),
    fk_support uuid not null,
    azimut smallint default 0,
    _inserted timestamp default now(),
    _last_modified timestamp default now(),
    CONSTRAINT fkey_od_support FOREIGN KEY (fk_support) REFERENCES siro_od.support (id) MATCH FULL DEFERRABLE INITIALLY DEFERRED,
    UNIQUE (fk_support, azimut) DEFERRABLE INITIALLY DEFERRED
);