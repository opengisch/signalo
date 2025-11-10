UPDATE signalo_db.vl_official_sign 
SET no_dynamic_inscription = 1
where value_fr LIKE '%1 ligne%';

UPDATE signalo_db.vl_official_sign 
SET no_dynamic_inscription = 2
where value_fr LIKE '%2 ligne%';

UPDATE signalo_db.vl_official_sign 
SET no_dynamic_inscription = 3
where value_fr LIKE '%3 ligne%';

UPDATE signalo_db.vl_official_sign 
SET value_de = 'Touristisch (3 Linien)'
where id = '0.1-3';

UPDATE signalo_db.vl_official_sign 
SET no_dynamic_inscription = 1
where id in ('0.2','0.3','1.10','1.11','2.16','2.17', '2.18', '2.19', '2.20','2.30', 
'2.47', '2.53', '2.59.1-NP', '2.59.2-NP', '4.07a', '4.10', '4.22', '4.23', '4.46',
'4.49', '4.50.1', '4.50.3', '4.50.4', '4.55', '4.56', '4.57', '4.58', '4.59', '4.59.1',
'4.66', '4.71', '4.73','4.77/10-2', '5.01', '5.02', '5.03','5.15', '5.17','5.31-3');

UPDATE signalo_db.vl_official_sign 
SET no_dynamic_inscription = 2
where id in ('4.36', '4.37', '4.40', '4.60', '4.62', '4.72', '4.90');

UPDATE signalo_db.vl_official_sign 
SET no_dynamic_inscription = 3
where id in ('4.28', '4.30', '4.35', '4.39', '4.41', '4.42-2', '4.42', '4.53', '4.54', '4.61', '4.67', '4.69');

UPDATE signalo_db.vl_official_sign 
SET no_dynamic_inscription = 4
where id in ('4.38', '4.64', '4.65', '4.68 ');

UPDATE signalo_db.vl_official_sign
SET value_de = 'Zonensignal Tempo-30-Zone',
    value_it = 'Segnale per zone 30'
where id = '2.59.1-30';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Zonensignal Parkverbot',
    value_it = 'Segnale per zone vietata al parcheggio'
where id = '2.59.1-NP';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Zonensignal Parkieren',
    value_it = 'Segnale per zone di parcheggio'
where id = '2.59.1-P';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Zonensignal Ende Tempo-30-Zone',
    value_it = 'Segnale per fine della zona 30',
    value_fr = 'Signal de fin de zone 30'
where id = '2.59.2-30';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Zonensignal Ende Parkverbot',
    value_it = 'Segnale per fine della zona vietata al parcheggio',
    value_fr = 'Signal de fin de zone sans stationnement'
where id = '2.59.2-NP';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Zonensignal Ende Parkieren',
    value_it = 'Segnale per fine della zona di parcheggio',
    value_fr = 'Signal de fin de zone de parc'
where id = '2.59.2-P';

UPDATE signalo_db.vl_official_sign
SET value_de = 'Wegweiser für Umleitungen ohne Zielangabe',
    value_it = 'Indicatore di direzione per deviazione senza menzione de luogo di destinazione',
    default_inscription1 = NULL
    where id = '4.34.1';

UPDATE signalo_db.vl_official_sign
SET default_inscription1 = NULL
    where id = '4.51.1';

UPDATE signalo_db.vl_official_sign
SET default_inscription2 = NULL
    where id = '5.00-1';
