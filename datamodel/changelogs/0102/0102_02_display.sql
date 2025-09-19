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
SET img_height = 100,
    img_width = 100
      WHERE id = '5.58';

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

UPDATE signalo_db.vl_official_sign
SET img_height = 60,
    img_width = 236
      WHERE id = '0.1';

UPDATE signalo_db.vl_official_sign
SET img_height = 60,
    img_width = 236
      WHERE id = '0.1-2';

UPDATE signalo_db.vl_official_sign
SET img_height = 60,
    img_width = 236
      WHERE id = '0.1-3';

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.42-2', true,
    'Einspurtafel über Fahrstreifen auf Nebenstrassen (2 Linien)',
    'Panneau de présélection au-dessus d''une voie de circulation sur route secondaire (2 lignes)',
    'Cartello di preselezione collocato al di sopra di una corsia su strada secondaria (2 ligne)',
    '442-2.svg', '442-2.svg', '442-2.svg', '442-2.svg',
    200, 208,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.34.2-1', true,
    'Fortführung Umleitung geradeaus (1 Linie)',
    'Continuation de la déviation tout droit (1 ligne)',
    'Proseguimento della deviazione in linea retta (1 linea)',
    '434a-2-1.svg', '434a-2-1.svg', '434a-2-1.svg', '434a-2-1.svg',
    60, 241,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.34.2-2', true,
    'Fortführung Umleitung geradeaus (2 Linien)',
    'Continuation de la déviation tout droit (2 lignes)',
    'Proseguimento della deviazione in linea retta (2 linee)',
    '434a-2-2.svg', '434a-2-2.svg', '434a-2-2.svg', '434a-2-2.svg',
    60, 241,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.34.2-3', true,
    'Fortführung Umleitung geradeaus (3 Linien)',
    'Continuation de la déviation tout droit (3 lignes)',
    'Proseguimento della deviazione in linea retta (3 linee)',
    '434a-2-3.svg', '434a-2-3.svg', '434a-2-3.svg', '434a-2-3.svg',
    79, 241,
    false);

INSERT INTO signalo_db.vl_official_sign(
    id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
    VALUES ('0.1-1.1', true,
    'Touristisch nicht richtungsweisend (1 Linie)',
    'Touristique non directionnel (1 ligne)',
    'Turistico non direzionale (1 linea)',
    '01-touristic-1.svg', '01-touristic-1.svg', '01-touristic-1.svg', '01-touristic-1.svg',
    80, 110,
    false);


    INSERT INTO signalo_db.vl_official_sign(
    id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
    VALUES ('0.1-2.1', true,
    'Touristisch nicht richtungsweisend (2 Linien)',
    'Touristique non directionnel (2 lignes)',
    'Turistico non direzionale (2 linee)',
    '01-touristic-2.svg', '01-touristic-2.svg', '01-touristic-2.svg', '01-touristic-2.svg',
    80, 110,
    false);

    INSERT INTO signalo_db.vl_official_sign(
    id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
    VALUES ('0.1-3.1', true,
    'Touristisch nicht richtungsweisend (3 Linien)',
    'Touristique non directionnel (3 lignes)',
    'Turistico non direzionale (3 linee)',
    '01-touristic-3.svg', '01-touristic-3.svg', '01-touristic-3.svg', '01-touristic-3.svg',
    80, 110,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('0.1-1.2', true,
    'Touristisch geradeaus (1 Linie)',
    'Touristique tout droit (1 ligne)',
    'Turistico dritto (1 linea)',
    '01-touristic-1a.svg', '01-touristic-1a.svg', '01-touristic-1a.svg', '01-touristic-1a.svg',
    60, 241,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('0.1-2.2', true,
    'Touristisch geradeaus (2 Linien)',
    'Touristique tout droit (2 lignes)',
    'Turistico dritto (2 linee)',
    '01-touristic-2a.svg', '01-touristic-2a.svg', '01-touristic-2a.svg', '01-touristic-2a.svg',
    60, 241,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('0.1-3.2', true,
    'Touristisch geradeaus (3 Linien)',
    'Touristique tout droit (3 lignes)',
    'Turistico dritto (3 linee)',
    '01-touristic-3a.svg', '01-touristic-3a.svg', '01-touristic-3a.svg', '01-touristic-3a.svg',
    79, 241,
    false);

    INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.34.3-1', true,
    'Umleitung nicht richtungsweisend (1 Linie)',
    'Déviation non directionnelle (1 ligne)',
    'Deviazione non direzionale  (1 linea)',
    '434a-3-1.svg', '434a-3-1.svg', '434a-3-1.svg', '434a-3-1.svg',
    60, 241,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.34.3-2', true,
    'Umleitung nicht richtungsweisend (2 Linien)',
    'Déviation non directionnelle (2 lignes)',
    'Deviazione non direzionale (2 linee)',
    '434a-3-2.svg', '434a-3-2.svg', '434a-3-2.svg', '434a-3-2.svg',
    60, 241,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.34.3-3', true,
    'Umleitung nicht richtungsweisend (3 Linien)',
    'Déviation non directionnelle (3 lignes)',
    'Deviazione non direzionale (3 linee)',
    '434a-3-3.svg', '434a-3-3.svg', '434a-3-3.svg', '434a-3-3.svg',
    79, 241,
    false);

UPDATE signalo_db.vl_official_sign
    SET directional_sign = true,
    img_de_right = '507-r.svg',
    img_fr_right = '507-r.svg',
    img_it_right = '507-r.svg',
    img_ro_right = '507-r.svg',
    img_de = '507-l.svg',
    img_fr = '507-l.svg',
    img_it = '507-l.svg',
    img_ro = '507-l.svg'
      WHERE id = '5.07';

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.09.1', true,
    'Sackgasse mit Ausnahmen (Fahrrad, Fussgänger)',
    'Impasse avec exceptions (vélo, piéton)',
    'Strada senza uscita con eccezioni (bicicletta, pedone)',
    '409-1.svg', '409-1.svg', '409-1.svg', '409-1.svg',
    100, 100,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('5.04.1', true,
    'Wiederholungstafel (horizontal)',
    'Plaque de rappel (horizontal)',
    'Cartelo di ripetizione (orizzontale)',
    '504-1.svg', '504-1.svg', '504-1.svg', '504-1.svg',
    34, 100,
    false);


UPDATE signalo_db.vl_official_sign
SET img_de = '477-28-1-l.svg',
    img_fr = '477-28-1-l.svg',
    img_it = '477-28-1-l.svg',
    img_ro = '477-28-1-l.svg',
    img_de_right = '477-28-1-r.svg',
    img_fr_right = '477-28-1-r.svg',
    img_it_right = '477-28-1-r.svg',
    img_ro_right = '477-28-1-r.svg',
    directional_sign = true
      WHERE id = '4.77/28-1';

UPDATE signalo_db.vl_official_sign
SET img_de = '477-28-2-l.svg',
    img_fr = '477-28-2-l.svg',
    img_it = '477-28-2-l.svg',
    img_ro = '477-28-2-l.svg',
    img_de_right = '477-28-2-r.svg',
    img_fr_right = '477-28-2-r.svg',
    img_it_right = '477-28-2-r.svg',
    img_ro_right = '477-28-2-r.svg',
    directional_sign = true
      WHERE id = '4.77/28-2';

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.77.2-1', true,
    'Freigabe des Pannenstreifens (Anfang)',
    'Ouverture de la bande d''arrêt d''urgence (début)',
    'Rilascio della corsia di emergenza (inizio)',
    '477-2-1.svg', '477-2-1.svg', '477-2-1.svg', '477-2-1.svg',
    100, 100,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.77.2-2', true,
    'Freigabe des Pannenstreifens (offen)',
    'Ouverture de la bande d''arrêt d''urgence (ouvert)',
    'Rilascio della corsia di emergenza (aperto)',
    '477-2-2.svg', '477-2-2.svg', '477-2-2.svg', '477-2-2.svg',
    100, 100,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.77.2-3', true,
    'Freigabe des Pannenstreifens (Ende, Ausfahrt)',
    'Ouverture de la bande d''arrêt d''urgence (fin, sortie)',
    'Rilascio della corsia di emergenza (fine, uscita)',
    '477-2-3.svg', '477-2-3.svg', '477-2-3.svg', '477-2-3.svg',
    100, 100,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.77/10-2', true,
    'Bestätigung der Anzahl Fahrstreifen (zwei, mit Geschwindigkeitsbegrenzung)',
    'Confirmation du nombre de voies de circulation (deux, avec réduction de vitesse)',
    'Conferma del numero di corsie di traffico (due, con riduzione della velocità)',
    '477-10-2.svg', '477-10-2.svg', '477-10-2.svg','477-10-2.svg',
    100, 70,
    false);

INSERT INTO signalo_db.vl_official_sign(
	id, active,
    value_de, value_fr, value_it,
    img_de, img_fr, img_it, img_ro,
    img_height, img_width,
    directional_sign)
	VALUES ('4.29-3', true,
    'Ortsbeginn auf Nebenstrassen (3 Linien)',
    'Début de localité sur route secondaire (3 lignes)',
    'Inizio della località sulle strade secondarie (3 ligne)',
    '429-3.svg', '429-3.svg', '429-3.svg','429-3.svg',
    80, 109,
    false);
