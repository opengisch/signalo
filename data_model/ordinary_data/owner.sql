


CREATE TABLE siro_od.owner
(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1(),
    active boolean default true,
    name text,
    _inserted_date timestamp default now(),
    _inserted_user text,
    _last_modified_date timestamp default now(),
    _last_modified_user text
);

INSERT INTO siro_od.owner (name) VALUES ('Commune');
INSERT INTO siro_od.owner (name) VALUES ('Canton');
INSERT INTO siro_od.owner (name) VALUES ('Confédération');
INSERT INTO siro_od.owner (name) VALUES ('Privé');