INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it,
	img_de, img_fr, img_it, img_ro, img_height, img_width,
	no_dynamic_inscription, default_inscription1,
	directional_sign)
	VALUES (
		'4.27-1',true,'Ortsbeginn auf Hauptstrassen (1 Linie)',
		'Début de localité sur route principale (1 ligne)',
		'Inizio della località sulle strade principali (1 ligne)',
		'427-1.svg', '427-1.svg', '427-1.svg', '427-1.svg', 80, 110,
		0, 'Biel',
		false);

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it,
	img_de, img_fr, img_it, img_ro, img_height, img_width,
	no_dynamic_inscription, default_inscription1, default_inscription2,
	directional_sign)
	VALUES (
		'4.27-2',true,'Ortsbeginn auf Hauptstrassen (2 Linien)',
		'Début de localité sur route principale (2 lignes)',
		'Inizio della località sulle strade principali (2 ligne)',
		'427-2.svg', '427-2.svg', '427-2.svg', '427-2.svg', 80, 110,
		0, 'Biel', 'Bienne',
		false);

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it,
	img_de, img_fr, img_it, img_ro, img_height, img_width,
	no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3,
	directional_sign)
	VALUES (
		'4.27-3',true,'Ortsbeginn auf Hauptstrassen (3 Linien)',
		'Début de localité sur route principale (3 lignes)',
		'Inizio della località sulle strade principali (3 ligne)',
		'427-3.svg', '427-3.svg', '427-3.svg', '427-3.svg', 80, 110,
		0, 'Biel', 'Bienne', 'BE',
		false);

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it,
	img_de, img_fr, img_it, img_ro, img_height, img_width,
	no_dynamic_inscription, default_inscription1,
	directional_sign)
	VALUES (
		'4.29-1', true, 'Ortsbeginn auf Nebenstrassen (1 Linie)',
		'Début de localité sur route secondaire (1 ligne)',
		'Inizio della località sulle strade secondarie (1 ligne)',
		'429-1.svg', '429-1.svg', '429-1.svg', '429-1.svg', 80, 109,
		0, 'Maur',
		false);

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it,
	img_de, img_fr, img_it, img_ro, img_height, img_width,
	no_dynamic_inscription, default_inscription1, default_inscription2,
	directional_sign)
	VALUES (
		'4.29-2', true, 'Ortsbeginn auf Nebenstrassen (2 Linien)',
		'Début de localité sur route secondaire (2 lignes)',
		'Inizio della località sulle strade secondarie (2 ligne)',
		'429-2.svg', '429-2.svg', '429-2.svg', '429-2.svg', 80, 109,
		0, 'Maur', '(ZH)',
		false);


UPDATE signalo_db.sign SET fk_official_sign = '4.27-3' where fk_official_sign = '4.27';
UPDATE signalo_db.sign SET fk_official_sign = '4.29-1' where fk_official_sign = '4.29';

DELETE from signalo_db.vl_official_sign where id = '4.27';
DELETE from signalo_db.vl_official_sign where id = '4.29';
