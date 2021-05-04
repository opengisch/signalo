


CREATE TABLE siro_od.owner
(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1(),
    name text,
    _inserted timestamp default now(),
    _last_modified timestamp default now()
);

INSERT INTO siro_od.owner (name) VALUES ('Commune');
INSERT INTO siro_od.owner (name) VALUES ('Canton');
INSERT INTO siro_od.owner (name) VALUES ('Confédération');
INSERT INTO siro_od.owner (name) VALUES ('Privé');