-- Insert supports

INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (1,1,1,ST_GeomFromText('POINT(2538388.0 1152589.8)',2056));
INSERT INTO siro_od.support(id,fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES ('00000000-0000-0000-0000-000000000001',1,1,1,ST_GeomFromText('POINT(2537954.42 1152523.14)',2056));
INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (3,2,1,ST_GeomFromText('POINT(2538449.48 1152512.22)',2056));

-- Insert frame

INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000002',1,1,1,true,1,'00000000-0000-0000-0000-000000000001');
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000003',2,1,1,true,1,'00000000-0000-0000-0000-000000000001');
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000004',3,1,1,true,1,'00000000-0000-0000-0000-000000000001');
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000005',4,1,1,true,1,'00000000-0000-0000-0000-000000000001');
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000006',5,1,1,true,1,'00000000-0000-0000-0000-000000000001');
INSERT INTO siro_od.frame(id,rank,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support) VALUES ('00000000-0000-0000-ffff-000000000007',6,1,1,true,1,'00000000-0000-0000-0000-000000000001');

-- Insert signs
--                                                                                                                           id,                      ,rank azimut fk_sign_type fk_official_sign fk_durability fk_status   fk_frame
INSERT INTO siro_od.sign(id,rank,azimut,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000000000001',  1 ,  20  ,   1        ,      '1.01'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000002');
INSERT INTO siro_od.sign(id,rank,azimut,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000000000002',  2 ,  20  ,   1        ,      '4.52'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000002');
INSERT INTO siro_od.sign(id,rank,azimut,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000000000003',  1 ,  19  ,   1        ,      '1.03'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000003');
INSERT INTO siro_od.sign(id,rank,azimut,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000000000004',  1 ,  214 ,   1        ,      '1.25a'   ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000004');
INSERT INTO siro_od.sign(id,rank,azimut,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000000000005',  1 ,  210 ,   1        ,      '1.30'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000005');
INSERT INTO siro_od.sign(id,rank,azimut,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000000000006',  1 ,  180 ,   1        ,      '2.15.1'  ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000006');
INSERT INTO siro_od.sign(id,rank,azimut,fk_sign_type,fk_official_sign,fk_durability,fk_status,fk_frame) VALUES ('00000000-0000-0000-eeee-000000000007',  1 ,  180 ,   1        ,      '2.16'    ,        1    ,    1     ,'00000000-0000-0000-ffff-000000000007');
