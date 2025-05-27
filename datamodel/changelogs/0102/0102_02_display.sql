-- add missing dimensions

UPDATE signalo_db.vl_official_sign
SET img_height = 100,
    img_width = 65 WHERE id = '4.51.3';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Obligatorische Richtung für Fahrzeuge, die gefährliche Güter befördern (rechts)',
    value_fr = 'Sens obligatoire pour les véhicules transportant des marchandises dangereuses (droite)',
    value_it = 'Direzione obbligatoria per i veicoli che trasportano merci pericolose (destra)'
      WHERE id = '2.41.2';


INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('2.41.2a', true,
    'Obligatorische Richtung für Fahrzeuge, die gefährliche Güter befördern (links)',
    'Sens obligatoire pour les véhicules transportant des marchandises dangereuses (gauche)',
    'Direzione obbligatoria per i veicoli che trasportano merci pericolose (sinistra)',
    '241-2a.svg', '241-2a.svg', '241-2a.svg', '241-2a.svg',
    100, 72,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('2.41.2b', true,
    'Obligatorische Richtung für Fahrzeuge, die gefährliche Güter befördern (geradeaus)',
    'Sens obligatoire pour les véhicules transportant des marchandises dangereuses (tout droit)',
    'Direzione obbligatoria per i veicoli che trasportano merci pericolose (diritto)',
    '241-2b.svg', '241-2b.svg', '241-2b.svg', '241-2b.svg',
    100, 72,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.21-1', true,
    'Parkhaus mit Parkscheibe',
    'Parking couvert avec disque de stationnement',
    'Parcheggio coperto con disco',
    '421-1.svg', '421-1.svg', '421-1.svg', '421-1.svg',
    100, 72,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.21-2', true,
    'Parkhaus gegen Gebühr',
    'Parking couvert contre paiement',
    'Parcheggio coperto contro pagamento',
    '421-2.svg', '421-2.svg', '421-2.svg', '421-2.svg',
    100, 72,
    false);

UPDATE signalo_db.vl_official_sign
SET img_de = '422-l.svg',
    img_fr = '422-l.svg',
    img_it = '422-l.svg',
    img_ro = '422-l.svg',
    img_de_right = '422-r.svg',
    img_fr_right = '422-r.svg',
    img_it_right = '422-r.svg',
    img_ro_right = '422-r.svg',
    directional_sign = true
      WHERE id = '4.22';

UPDATE signalo_db.vl_official_sign
SET img_de = '423-l.svg',
    img_fr = '423-l.svg',
    img_it = '423-l.svg',
    img_ro = '423-l.svg',
    img_de_right = '423-r.svg',
    img_fr_right = '423-r.svg',
    img_it_right = '423-r.svg',
    img_ro_right = '423-r.svg',
    directional_sign = true
      WHERE id = '4.23';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Parkhaus mit Anschluss an öffentliches Verkehrsmittel',
    value_fr = 'Parking couvert avec accès aux transports publics',
    value_it = 'Parcheggio coperto con collegamento a un mezzo di trasporto pubblico'
      WHERE id = '4.25a';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Parkplatz mit Anschluss an öffentliches Verkehrsmittel (Zug)',
    value_fr = 'Parking avec accès aux transports publics (train)',
    value_it = 'Parcheggio con collegamento a un mezzo di trasporto pubblico (treno)',
    img_width = 72
      WHERE id = '4.25b';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Parkplatz mit Anschluss an öffentliches Verkehrsmittel (Tram)',
    value_fr = 'Parking avec accès aux transports publics (tram)',
    value_it = 'Parcheggio con collegamento a un mezzo di trasporto pubblico (tram)',
    img_height = 100,
    img_width = 72
      WHERE id = '4.25c';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Parkplatz mit Anschluss an öffentliches Verkehrsmittel (Bus)',
    value_fr = 'Parking avec accès aux transports publics (bus)',
    value_it = 'Parcheggio con collegamento a un mezzo di trasporto pubblico (autobus)',
    img_height = 100,
    img_width = 72
      WHERE id = '4.25d';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Parkplatz mit Anschluss an öffentliches Verkehrsmittel',
    value_it = 'Parcheggio con collegamento a un mezzo di trasporto pubblico'
      WHERE id = '4.25';

UPDATE signalo_db.vl_official_sign
SET img_height = 100,
    img_width = 100
      WHERE id = '5.54';

UPDATE signalo_db.vl_official_sign
SET img_height = 35,
    img_width = 175
      WHERE id = '4.50.1';

UPDATE signalo_db.vl_official_sign
SET img_height = 35,
    img_width = 175
      WHERE id = '4.50.3';

UPDATE signalo_db.vl_official_sign
SET img_height = 35,
    img_width = 175
      WHERE id = '4.50.4';
