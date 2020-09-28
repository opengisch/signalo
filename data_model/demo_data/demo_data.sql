-- Insert supports

INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (1,1,1,ST_GeomFromText('POINT(2538388.0 1152589.8)',2056));
INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (1,1,1,ST_GeomFromText('POINT(2537954.42 1152523.14)',2056));
INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (3,2,1,ST_GeomFromText('POINT(2538449.48 1152512.22)',2056));

-- Insert signs

INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut)
VALUES (1,1,1,20);
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut)
VALUES (1,3,1,20);
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut)
VALUES (1,1,1,100);
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut)
VALUES (1,1,1,100);
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut)
VALUES (1,1,1,100);
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut)
VALUES (1,1,1,100);

-- Insert frame

INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1);
