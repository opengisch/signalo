

CREATE TABLE siro_vl.support_type
(
  id serial PRIMARY KEY,
  value_en text,
  value_fr text,
  value_de text,
);

INSERT INTO siro_vl (id, value_en, value_fr, value_de) VALUES (1, 'tubular', 'tubulaire', 'tubular');
INSERT INTO siro_vl (id, value_en, value_fr, value_de) VALUES (2, 'triangulate', 'triangulé', 'triangulate');
INSERT INTO siro_vl (id, value_en, value_fr, value_de) VALUES (3, 'gantry', 'portique', 'gantry');
INSERT INTO siro_vl (id, value_en, value_fr, value_de) VALUES (4, 'lamppost', 'candélabre', 'lamppost');
INSERT INTO siro_vl (id, value_en, value_fr, value_de) VALUES (5, 'jib', 'potence', 'jib');
INSERT INTO siro_vl (id, value_en, value_fr, value_de) VALUES (6, 'facade', 'façade', 'facade');
INSERT INTO siro_vl (id, value_en, value_fr, value_de) VALUES (7, 'wall', 'mur', 'wall');
INSERT INTO siro_vl (id, value_en, value_fr, value_de) VALUES (8, 'other', 'autre', 'other');