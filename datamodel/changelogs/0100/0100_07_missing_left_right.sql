UPDATE signalo_db.vl_official_sign
SET value_de = 'Fussgänger-Überführung (linksgehend)',
    value_fr = 'Passerelle pour piétons (vers la gauche)',
    value_it = 'Cavalcavia pedonale (a sinistra)' WHERE id = '4.13';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Fussgänger-Überführung (rechtsgehend)',
    value_fr = 'Passerelle pour piétons (vers la droite)',
    value_it = 'Cavalcavia pedonale (a destra)' WHERE id = '4.13a';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Fussgänger-Unterführung (linksgehend)',
    value_fr = 'Passage souterrain pour piétons (vers la gauche)',
    value_it = 'Sottopassaggio pedonale (a sinistra)' WHERE id = '4.12';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Fussgänger-Unterführung (rechtsgehend)',
    value_fr = 'Passage souterrain pour piétons (vers la droite)',
    value_it = 'Sottopassaggio pedonale (a destra)' WHERE id = '4.12a';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Standort eines Fussgängerstreifens (linksgehend)',
    value_fr = 'Emplacement d''un passage pour piétons (vers la gauche)',
    value_it = 'Ubicazione di un passaggio pedonale (a sinistra)' WHERE id = '4.11';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Standort eines Fussgängerstreifens (rechtsgehend)',
    value_fr = 'Emplacement d''un passage pour piétons (vers la droite)',
    value_it = 'Ubicazione di un passaggio pedonale (a destra)' WHERE id = '4.11a';

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, directional_sign)
	VALUES ('2.61-a', true, 'Ende des Fusswegs',
    'Fin du chemin pour piétons',
    'Fine della strada pedonale', '261-a.svg', '261-a.svg', '261-a.svg', '261-a.svg',
    100, 100, 0, false);

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, directional_sign)
	VALUES ('2.62-a', true, 'Ende des Reitwegs',
    'Fin de l''allée d''équitation',
    'Fine della strada per cavalli da sella', '262-a.svg', '262-a.svg', '262-a.svg', '262-a.svg',
    100, 100, 0, false);

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, directional_sign)
	VALUES ('2.63-a', true, 'Ende des Rad- und Fusswegs mit getrennten Verkehrsflächen (Beispiel)',
    'Fin de la piste cyclable et chemin pour piétons, sans partage de l''aire de circulation (exemple)',
    'Fine della ciclopista e strada pedonale divise per categoria (esempio)', '263-a.svg', '263-a.svg', '263-a.svg', '263-a.svg',
    100, 99, 0, false);

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, directional_sign)
	VALUES ('2.63-1-a', true, 'Ende des gemeinsamen Rad- und Fusswegs (Beispiel)',
    'Fin de la piste cyclable et chemin pour piétons, avec partage de l''aire de circulation (exemple)',
    'Fine della ciclopista e strada pedonale (esempio)', '263-1-a.svg', '263-1-a.svg', '263-1-a.svg', '263-1-a.svg',
    100, 99, 0, false);

-- correct french description for 2.63 and 2.63.1 (they were switched)
UPDATE signalo_db.vl_official_sign
SET value_fr = 'Piste cyclable et chemin pour piétons, avec partage de l''aire de circulation (exemple)'
WHERE id = '2.63.1';

UPDATE signalo_db.vl_official_sign
SET value_fr = 'Piste cyclable et chemin pour piétons, sans partage de l''aire de circulation (exemple)'
WHERE id = '2.63';

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, directional_sign)
	VALUES ('2.64-a', true, 'Ende der Busfahrbahn',
    'Fin de chaussée réservée au bus',
    'Fine della carreggiata riservata ai bus', '264-a.svg', '264-a.svg', '264-a.svg', '264-a.svg',
    100, 100, 0, false);

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription,
    default_inscription1, default_inscription2, directional_sign,
    img_de_right, img_fr_right, img_it_right, img_ro_right)
	VALUES ('4.34-2', true, 'Wegweiser bei Umleitungen (2 Linien)',
    'Indicateur de direction pour déviation (2 lignes)',
    'Indicatore di direzione per deviazione (2 ligne)',
    '434-2-l.svg', '434-2-l.svg', '434-2-l.svg', '434-2-l.svg',
    60, 241, 0, 'Lugano','Bellinzona',true,
    '434-2-r.svg', '434-2-r.svg', '434-2-r.svg', '434-2-r.svg');

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription,
    default_inscription1, default_inscription2, default_inscription3, directional_sign,
    img_de_right, img_fr_right, img_it_right, img_ro_right)
	VALUES ('4.34-3', true, 'Wegweiser bei Umleitungen (3 Linien)',
    'Indicateur de direction pour déviation (3 lignes)',
    'Indicatore di direzione per deviazione (3 ligne)',
    '434-3-l.svg', '434-3-l.svg', '434-3-l.svg', '434-3-l.svg',
    60, 241, 0, 'Lugano','Bellinzona','Locarno',true,
    '434-3-r.svg', '434-3-r.svg', '434-3-r.svg', '434-3-r.svg');

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, value_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription,
    default_inscription1, default_inscription2, default_inscription3, directional_sign,
    img_de_right, img_fr_right, img_it_right, img_ro_right)
	VALUES ('0.1-2', true, 'Touristisch (2 Linien)',
    'Touristique (2 lignes)',
    'Turistico (2 ligne)',
    'Turissem (2 lingias)',
    '01-touristic-2-l.svg', '01-touristic-2-l.svg', '01-touristic-2-l.svg', '01-touristic-2-l.svg',
    37, 145, 0, 'Chateau','Lac',NULL,true,
    '01-touristic-2-r.svg', '01-touristic-2-r.svg', '01-touristic-2-r.svg', '01-touristic-2-r.svg');

INSERT INTO signalo_db.vl_official_sign(
	id, active, value_de, value_fr, value_it, value_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription,
    default_inscription1, default_inscription2, default_inscription3, directional_sign,
    img_de_right, img_fr_right, img_it_right, img_ro_right)
	VALUES ('0.1-3', true, 'Touristisch (2 Linien)',
    'Touristique (3 lignes)',
    'Turistico (3 ligne)',
    'Turissem (3 lingias)',
    '01-touristic-3-l.svg', '01-touristic-3-l.svg', '01-touristic-3-l.svg', '01-touristic-3-l.svg',
    37, 145, 0, 'Chateau','Lac','Montagne',true,
    '01-touristic-3-r.svg', '01-touristic-3-r.svg', '01-touristic-3-r.svg', '01-touristic-3-r.svg');

UPDATE signalo_db.vl_official_sign
    SET value_ro = 'Turissem (1 lingia)',
    value_de = 'Touristisch (1 Linie)',
    value_fr = 'Touristique (1 ligne)',
    value_it = 'Turistico (1 ligne)',
    img_de = '01-touristic-1-l.svg', img_fr = '01-touristic-1-l.svg', img_it = '01-touristic-1-l.svg', img_ro = '01-touristic-1-l.svg',
    img_de_right = '01-touristic-1-r.svg', img_fr_right = '01-touristic-1-r.svg', img_it_right = '01-touristic-1-r.svg', img_ro_right = '01-touristic-1-r.svg'
    WHERE id = '0.1';