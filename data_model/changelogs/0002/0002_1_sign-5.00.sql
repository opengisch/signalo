

INSERT INTO signalo_db.vl_official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.00-1', true, 'TBT (1 ligne)', 'Plaque complémentaire (1 ligne)', 'TBT (1 ligne)', NULL, NULL, NULL, NULL, NULL, '500-1.svg', '500-1.svg', '500-1.svg', '500-1.svg', 60, 175, 0, '80', '800 m', NULL, NULL);
INSERT INTO signalo_db.vl_official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.00-2', true, 'TBT (2 lignes)', 'Plaque complémentaire (2 lignes)', 'TBT (2 lignes)', NULL, NULL, NULL, NULL, NULL, '500-2.svg', '500-2.svg', '500-2.svg', '500-2.svg', 60, 175, 0, '80', '800 m', '900 m', NULL);
INSERT INTO signalo_db.vl_official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.00-3', true, 'TBT (3 lignes)', 'Plaque complémentaire (3 lignes)', 'TBT (3 lignes)', NULL, NULL, NULL, NULL, NULL, '500-3.svg', '500-3.svg', '500-3.svg', '500-3.svg', 60, 175, 0, '80', '800 m', '900 m', '500 m');

UPDATE signalo_db.sign SET fk_official_sign = '5.00-1' WHERE fk_official_sign = '5.00';

DELETE FROM signalo_db.vl_official_sign WHERE id '5.00';
