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
where id = '0.1-3'

UPDATE signalo_db.vl_official_sign 
SET no_dynamic_inscription = 1
where id in ('0.3','1.10','1.11','2.16','2.17', '2.18', '2.19', '2.20','2.30', '2.47', '2.53', '2.59.1-NP', '2.59.2-NP'  );

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