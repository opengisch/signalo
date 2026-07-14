UPDATE signalo_db.vl_official_sign
SET value_de = 'Mindestgeschwindigkeit',
    no_dynamic_inscription = 1,
    default_inscription1 = '30'
      WHERE id = '2.31';

UPDATE signalo_db.vl_official_sign
SET no_dynamic_inscription = 1,
    default_inscription1 = '30'
      WHERE id = '2.54';