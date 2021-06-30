-- Insert supports
INSERT INTO signalo_od.support (fk_support_type,fk_support_base_type,fk_status,geometry) VALUES (1,1,1,ST_GeomFromText('POINT(2538388.0 1152589.8)',2056));
INSERT INTO signalo_od.support (id,fk_support_type,fk_support_base_type,fk_status,geometry) VALUES ('00000000-0000-0000-0000-000000000001',1,1,1,ST_GeomFromText('POINT(2537954.42 1152523.14)',2056));
INSERT INTO signalo_od.support (id,fk_support_type,fk_support_base_type,fk_status,geometry) VALUES ('00000000-0000-0000-0000-000000000002',3,2,1,ST_GeomFromText('POINT(2538449.48 1152512.22)',2056));

-- Insert azimut
INSERT INTO signalo_od.azimut (id, fk_support, azimut) VALUES ('00000000-0000-0000-aaaa-000000000101', '00000000-0000-0000-0000-000000000001', 15);
INSERT INTO signalo_od.azimut (id, fk_support, azimut) VALUES ('00000000-0000-0000-aaaa-000000000102', '00000000-0000-0000-0000-000000000001', 175);
INSERT INTO signalo_od.azimut (id, fk_support, azimut) VALUES ('00000000-0000-0000-aaaa-000000000103', '00000000-0000-0000-0000-000000000001', 235);
INSERT INTO signalo_od.azimut (id, fk_support, azimut) VALUES ('00000000-0000-0000-aaaa-000000000201', '00000000-0000-0000-0000-000000000002', 47);
INSERT INTO signalo_od.azimut (id, fk_support, azimut) VALUES ('00000000-0000-0000-aaaa-000000000202', '00000000-0000-0000-0000-000000000002', 165);

-- Insert frame                                                                                                                            rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000010101',  1 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000101'); -- support 1 azimut 1
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000010102',  2 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000101'); -- support 1 azimut 1
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000010201',  1 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000102'); -- support 1 azimut 2
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000010202',  2 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000102'); -- support 1 azimut 2
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000010203',  3 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000102'); -- support 1 azimut 2
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000010301',  1 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000103'); -- support 1 azimut 3
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000010302',  2 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000103'); -- support 1 azimut 3
--
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000020101',  1 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000201'); -- support 2 azimut 1
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000020201',  1 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000202'); -- support 2 azimut 2
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000020202',  2 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000202'); -- support 2 azimut 2
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000020203',  3 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000202'); -- support 2 azimut 2
INSERT INTO signalo_od.frame (id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_azimut) VALUES ('00000000-0000-0000-ffff-000000020204',  4 ,    1        ,      1             ,      1  ,'00000000-0000-0000-aaaa-000000000202'); -- support 2 azimut 2


-- Insert signs                                                                                                        id,              S A F R  rank,fk_sign_type,fk_official_sign fk_durability fk_status   fk_frame
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001010101',  1 ,   1        ,      '1.01'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000010101'); -- support 1, azimut 1, frame 1, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001010102',  2 ,   1        ,      '4.52'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000010101'); -- support 1, azimut 1, frame 1, rank 2
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001010201',  1 ,   1        ,      '1.03'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000010102'); -- support 1, azimut 1, frame 2, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001020101',  1 ,   1        ,      '1.14'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000010201'); -- support 1, azimut 2, frame 1, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001020201',  1 ,   1        ,      '1.25a'   ,        1    ,    1     ,'00000000-0000-0000-ffff-000000010202'); -- support 1, azimut 2, frame 2, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001020301',  1 ,   1        ,      '1.30'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000010203'); -- support 1, azimut 2, frame 3, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001030101',  1 ,   1        ,      '2.15.1'  ,        1    ,    1     ,'00000000-0000-0000-ffff-000000010301'); -- support 1, azimut 3, frame 1, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001030201',  1 ,   1        ,      '2.16'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000010302'); -- support 1, azimut 3, frame 2, rank 1
-- Insert signs                                                                                                        id,              S A F R  rank,fk_sign_type,fk_official_sign fk_durability fk_status   fk_frame
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002010101',  1 ,   1        ,      '1.01'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020101'); -- support 2, azimut 1, frame 1, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020101',  1 ,   1        ,      '4.52'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020201'); -- support 2, azimut 2, frame 1, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020201',  1 ,   1        ,      '1.03'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020202'); -- support 2, azimut 2, frame 2, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020202',  2 ,   1        ,      '1.14'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020202'); -- support 2, azimut 2, frame 2, rank 2
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020203',  3 ,   1        ,      '1.14'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020202'); -- support 2, azimut 2, frame 2, rank 3
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020301',  1 ,   1        ,      '1.25a'   ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020203'); -- support 2, azimut 2, frame 3, rank 1
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020401',  1 ,   1        ,      '1.30'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020204'); -- support 2, azimut 2, frame 4, rank 1
-- Insert verso signs
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame,verso) VALUES ('00000000-0000-0000-eeee-000012020201',  1 ,   1        ,      '1.30'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020202', true); -- support 2, azimut 2, frame 2, rank 1 VERSO
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame,verso) VALUES ('00000000-0000-0000-eeee-000012020202',  2 ,   1        ,      '1.30'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020202', true); -- support 2, azimut 2, frame 2, rank 2 VERSO
INSERT INTO signalo_od.sign (id,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame,verso) VALUES ('00000000-0000-0000-eeee-000012020203',  1 ,   1        ,      '1.30'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000020203', true); -- support 2, azimut 2, frame 3, rank 1 VERSO

















