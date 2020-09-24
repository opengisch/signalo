

CREATE TABLE siro_vl.support_type
(
  id serial PRIMARY KEY,
  active boolean default true,
  value_en text,
  value_fr text,
  value_de text
);

INSERT INTO siro_vl.support_type (id, value_en, value_fr, value_de) VALUES (1, 'unknown', 'inconnu', 'unknown');
INSERT INTO siro_vl.support_type (id, value_en, value_fr, value_de) VALUES (2, 'other', 'autre', 'other');
INSERT INTO siro_vl.support_type (id, value_en, value_fr, value_de) VALUES (3, 'to be determined', 'à déterminer', 'to be determined');


INSERT INTO siro_vl.support_type (id, value_en, value_fr, value_de) VALUES (10, 'weld', 'soudé', 'weld');
INSERT INTO siro_vl.support_type (id, value_en, value_fr, value_de) VALUES (11, 'fit', 'emboîté', 'fit');
INSERT INTO siro_vl.support_type (id, value_en, value_fr, value_de) VALUES (12, 'with runner', 'avec glissières', 'with runner');
INSERT INTO siro_vl.support_type (id, value_en, value_fr, value_de) VALUES (13, 'Side mounting', 'A fixation latérale', 'Side mounting');

