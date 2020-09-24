


CREATE TABLE siro_vl.coating
(
  id serial primary key,
  active boolean default true,
  value_en text,
  value_fr text,
  value_de text
);

INSERT INTO siro_vl.status (id, value_en, value_fr, value_de) VALUES (1, 'unknown', 'inconnu', 'unknown');
INSERT INTO siro_vl.status (id, value_en, value_fr, value_de) VALUES (2, 'other', 'autre', 'other');
INSERT INTO siro_vl.status (id, value_en, value_fr, value_de) VALUES (3, 'to be determined', 'à déterminer', 'to be determined');

INSERT INTO siro_vl.durability (id, value_en, value_fr, value_de) VALUES (1, 'xxx', 'xxx', 'xxx');
