-- move provider info to demo data

DELETE FROM signalo_db.vl_provider where name in ('L. Ellgass SA','Signal SA','BO-Plastiline SA');

-- delete custom support base type data

DELETE FROM signalo_db.vl_support_base_type where id = 16 and value_de = 'SPCH–Type 3';
DELETE FROM signalo_db.vl_support_base_type where id = 17 and value_de = 'SPCH–Type 4';
DELETE FROM signalo_db.vl_support_base_type where id = 18 and value_de = 'SPCH-Type 5';
DELETE FROM signalo_db.vl_support_base_type where id = 19 and value_de = 'SPCH-Type 6';
DELETE FROM signalo_db.vl_support_base_type where id = 20 and value_de = 'OFROU-Type A';
DELETE FROM signalo_db.vl_support_base_type where id = 21 and value_de = 'OFROU-Type B';
DELETE FROM signalo_db.vl_support_base_type where id = 22 and value_de = 'OFROU-Type C';
DELETE FROM signalo_db.vl_support_base_type where id = 23 and value_de = 'OFROU-Type D';
DELETE FROM signalo_db.vl_support_base_type where id = 24 and value_de = 'OFROU-Type E';
DELETE FROM signalo_db.vl_support_base_type where id = 25 and value_de = 'OFROU-Type F';
DELETE FROM signalo_db.vl_support_base_type where id = 26 and value_de = 'OFROU-Type 100';
DELETE FROM signalo_db.vl_support_base_type where id = 27 and value_de = 'OFROU-Type 150';
DELETE FROM signalo_db.vl_support_base_type where id = 28 and value_de = 'OFROU-Type 200';
DELETE FROM signalo_db.vl_support_base_type where id = 29 and value_de = 'OFROU-Type 250';
DELETE FROM signalo_db.vl_support_base_type where id = 30 and value_de = 'OFROU-Type 300';
DELETE FROM signalo_db.vl_support_base_type where id = 31 and value_de = 'OFROU-Type 300 DS';

INSERT INTO signalo_db.vl_support_base_type (id, active, value_de, value_fr) VALUES (33, true, 'Abnehmbarer Betonklotz', 'Plot en béton amovible');


-- add new value in vl_support_type

INSERT INTO signalo_db.vl_support_type (id, active, value_fr, value_de) VALUES (18, true, 'mât ligne de contact trolleybus', 'Oberleitungsmast Trolleybus');
