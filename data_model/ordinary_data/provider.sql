


CREATE TABLE siro_od.provider
(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1(),
    name text
);

INSERT INTO siro_od.owner (name) VALUES ('signal');