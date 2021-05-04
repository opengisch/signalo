


CREATE TABLE siro_od.provider
(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1(),
    name text,
    _inserted timestamp default now(),
    _last_modified timestamp default now()
);

INSERT INTO siro_od.owner (name) VALUES ('signal');