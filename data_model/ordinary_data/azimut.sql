


CREATE TABLE signalo_od.azimut
(
    id uuid PRIMARY KEY default uuid_generate_v1(),
    fk_support uuid not null,
    azimut smallint default 0,
    _inserted_date timestamp default now(),
    _inserted_user text,
    _last_modified_date timestamp default now(),
    _last_modified_user text,
    _edited boolean default false,
    CONSTRAINT fkey_od_support FOREIGN KEY (fk_support) REFERENCES signalo_od.support (id) MATCH FULL DEFERRABLE INITIALLY DEFERRED,
    UNIQUE (fk_support, azimut) DEFERRABLE INITIALLY DEFERRED
);