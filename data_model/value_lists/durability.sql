


CREATE TABLE siro_vl.durability
(
  id serial primary key,
  value_en text,
  value_fr text,
  value_de text,
);

INSERT INTO siro_vl.durability (id, value_en, value_fr, value_de) VALUES (1, 'permanent', 'permanent', 'permanent');
INSERT INTO siro_vl.durability (id, value_en, value_fr, value_de) VALUES (2, 'temporary', 'temporaire', 'temporary');
INSERT INTO siro_vl.durability (id, value_en, value_fr, value_de) VALUES (3, 'winter', 'hivernal', 'winter');
