


CREATE TABLE signalo_od.owner
(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1(),
    active boolean default true,
    name text,
    usr_owner_1 text,
    usr_owner_2 text,
    usr_owner_3 text,
    _inserted_date timestamp default now(),
    _inserted_user text,
    _last_modified_date timestamp default now(),
    _last_modified_user text
);

INSERT INTO signalo_od.owner (name) VALUES ('Commune');
INSERT INTO signalo_od.owner (name) VALUES ('Canton');
INSERT INTO signalo_od.owner (name) VALUES ('Confédération');
INSERT INTO signalo_od.owner (name) VALUES ('Privé');