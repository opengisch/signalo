

CREATE TABLE siro_vl.official_sign
(
  id text primary key,
  value_en text,
  value_fr text,
  value_de text,
  description_en text,
  description_fr text,
  description_en text,
);


INSERT INTO siro_vl.official_sign (id, value_en, value_fr, value_de) VALUES ('1.01', 'Right turn', 'Virage à droite', 'Right turn');
INSERT INTO siro_vl.official_sign (id, value_en, value_fr, value_de) VALUES ('1.02', 'Left turn', 'Virage à gauche', 'LEft turn');