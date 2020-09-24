


CREATE TABLE siro_od.owner
(
    id uuid PRIMARY KEY,
    name text,
);

INSERT INTO siro_od.owner (name) VALUES ('Commune');
INSERT INTO siro_od.owner (name) VALUES ('Canton');
INSERT INTO siro_od.owner (name) VALUES ('Confédération');
INSERT INTO siro_od.owner (name) VALUES ('Privé');