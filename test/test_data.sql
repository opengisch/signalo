-- Insert supports

INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry) VALUES (1,1,1,ST_GeomFromText('POINT(2538388.0 1152589.8)',2056));
INSERT INTO siro_od.support(id,fk_support_type,fk_support_base_type,fk_status,geometry) VALUES ('00000000-0000-0000-0000-000000000001',1,1,1,ST_GeomFromText('POINT(2537954.42 1152523.14)',2056));
INSERT INTO siro_od.support(id,fk_support_type,fk_support_base_type,fk_status,geometry) VALUES ('00000000-0000-0000-0000-000000000002',3,2,1,ST_GeomFromText('POINT(2538449.48 1152512.22)',2056));

-- Insert frame                                                                                                                           rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000101',  1 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000001'); -- suport 1
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000102',  2 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000001'); -- suport 1
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000103',  3 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000001'); -- suport 1
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000104',  4 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000001'); -- suport 1
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000105',  5 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000001'); -- suport 1
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000106',  6 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000001'); -- suport 1
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000107',  7 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000001'); -- suport 1
--
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000201',  1 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000002'); -- suport 2
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000202',  2 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000002'); -- suport 2
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000203',  3 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000002'); -- suport 2
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000204',  4 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000002'); -- suport 2
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000205',  5 ,    1        ,      1             ,      1  ,'00000000-0000-0000-0000-000000000002'); -- suport 2


-- Insert signs                                                                                                              id,              S F A R  azimut,rank,fk_sign_type,fk_official_sign fk_durability fk_status   fk_frame
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001010101',  20  ,  1 ,   1        ,      '1.01'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000101'); -- support 1, azimut 1, frame 1, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001010102',  20  ,  2 ,   1        ,      '4.52'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000101'); -- support 1, azimut 1, frame 1, rank 2
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001010201',  19  ,  1 ,   1        ,      '1.03'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000102'); -- support 1, azimut 1, frame 2, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001010301',  19  ,  1 ,   1        ,      '1.14'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000103'); -- support 1, azimut 1, frame 3, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001020401',  214 ,  1 ,   1        ,      '1.25a'   ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000104'); -- support 1, azimut 2, frame 4, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001020501',  210 ,  1 ,   1        ,      '1.30'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000105'); -- support 1, azimut 2, frame 5, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001030601',  180 ,  1 ,   1        ,      '2.15.1'  ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000106'); -- support 1, azimut 3, frame 6, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000001030701',  180 ,  1 ,   1        ,      '2.16'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000107'); -- support 1, azimut 3, frame 7, rank 1
-- Insert signs                                                                                                              id,              S F A R  azimut,rank,fk_sign_type,fk_official_sign fk_durability fk_status   fk_frame
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002010101',  20  ,  1 ,   1        ,      '1.01'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000201'); -- support 2, azimut 1, frame 1, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020201',  20  ,  1 ,   1        ,      '4.52'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000201'); -- support 2, azimut 1, frame 2, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002010202',  19  ,  2 ,   1        ,      '1.03'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000202'); -- support 2, azimut 1, frame 2, rank 2
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002010203',  19  ,  3 ,   1        ,      '1.14'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000203'); -- support 2, azimut 1, frame 2, rank 3
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002010301',  19  ,  1 ,   1        ,      '1.14'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000203'); -- support 2, azimut 1, frame 3, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020401',  214 ,  1 ,   1        ,      '1.25a'   ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000204'); -- support 2, azimut 2, frame 4, rank 1
INSERT INTO siro_od.sign(id,azimut,rank,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000002020501',  210 ,  1 ,   1        ,      '1.30'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000205'); -- support 2, azimut 2, frame 5, rank 1

















