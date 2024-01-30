DELETE FROM signalo_db.vl_official_sign where id = '5.02';

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4, directional_sign, img_de_right, img_fr_right, img_it_right, img_ro_right)
	VALUES (5.02, true, 'Anzeige von Entfernung und Richtung', 
    'Plaque indiquant la distance et la direction', 
    'Cartello indicante la distanza e la direzione', NULL, NULL, NULL, NULL, NULL, '502-l.svg', '502-l.svg', '502-l.svg', '502-l.svg', 80, 113, 0, '50 m', NULL, NULL, NULL, true, '502-r.svg', '502-r.svg', '502-r.svg', '502-r.svg');

