


CREATE TABLE siro_vl.status
(
  id serial primary key,
  value_en text,
  value_fr text,
  value_de text
);

INSERT INTO siro_vl.status (id, value_en, value_fr, value_de) VALUES (1, 'ok', 'fonctionnel', 'ok');
