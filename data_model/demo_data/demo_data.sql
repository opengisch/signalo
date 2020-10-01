-- Insert supports

INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (1,1,1,ST_GeomFromText('POINT(2538388.0 1152589.8)',2056));
INSERT INTO siro_od.support(id,fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES ('70cbdbbe-0320-11eb-9a46-0242ac110002',1,1,1,ST_GeomFromText('POINT(2537954.42 1152523.14)',2056));
INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (3,2,1,ST_GeomFromText('POINT(2538449.48 1152512.22)',2056));

-- Insert frame

INSERT INTO siro_od.frame(id,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support)
VALUES ('5869baae-0321-11eb-9a46-0242ac110002',1,1,true,1,'70cbdbbe-0320-11eb-9a46-0242ac110002');
INSERT INTO siro_od.frame(id,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support)
VALUES ('5869baae-0321-11eb-9a46-0242ac110003',1,1,true,1,'70cbdbbe-0320-11eb-9a46-0242ac110002');
INSERT INTO siro_od.frame(id,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support)
VALUES ('5869baae-0321-11eb-9a46-0242ac110004',1,1,true,1,'70cbdbbe-0320-11eb-9a46-0242ac110002');
INSERT INTO siro_od.frame(id,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support)
VALUES ('5869baae-0321-11eb-9a46-0242ac110005',1,1,true,1,'70cbdbbe-0320-11eb-9a46-0242ac110002');
INSERT INTO siro_od.frame(id,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support)
VALUES ('5869baae-0321-11eb-9a46-0242ac110006',1,1,true,1,'70cbdbbe-0320-11eb-9a46-0242ac110002');
INSERT INTO siro_od.frame(id,fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support)
VALUES ('5869baae-0321-11eb-9a46-0242ac110007',1,1,true,1,'70cbdbbe-0320-11eb-9a46-0242ac110002');

-- Insert signs

INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,20,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,3,1,19,'5869baae-0321-11eb-9a46-0242ac110003');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,214,'5869baae-0321-11eb-9a46-0242ac110004');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,210,'5869baae-0321-11eb-9a46-0242ac110005');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,180,'5869baae-0321-11eb-9a46-0242ac110006');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,180,'5869baae-0321-11eb-9a46-0242ac110007');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,20,'5869baae-0321-11eb-9a46-0242ac110002');
