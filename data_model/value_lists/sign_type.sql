


CREATE TABLE siro_vl.sign_type
(
  id serial primary key,
  value_en text,
  value_fr text,
  value_de text,
);

INSERT INTO siro_vl.sign_type (id, value_en, value_fr, value_de) VALUES (1, 'official', 'officiel', 'official');
INSERT INTO siro_vl.sign_type (id, value_en, value_fr, value_de) VALUES (2, 'touristic', 'touristique', 'touristic');
INSERT INTO siro_vl.sign_type (id, value_en, value_fr, value_de) VALUES (3, 'pedestrian', 'officiel', 'pedestrian');
INSERT INTO siro_vl.sign_type (id, value_en, value_fr, value_de) VALUES (4, 'hotel', 'hotel', 'hotel');