-- Insert supports

INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (1,1,1,ST_GeomFromText('POINT(2538388.0 1152589.8)',2056));
INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (1,1,1,ST_GeomFromText('POINT(2537954.42 1152523.14)',2056));
INSERT INTO siro_od.support(fk_support_type,fk_support_base_type,fk_status,geometry)
VALUES (3,2,1,ST_GeomFromText('POINT(2538449.48 1152512.22)',2056));

-- Insert signs

INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,20,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,3,1,15,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,214,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,165,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,310,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,22,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,171,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,212,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,360,'5869baae-0321-11eb-9a46-0242ac110002');
INSERT INTO siro_od.sign(fk_sign_type,fk_durability,fk_status,azimut,fk_frame)
VALUES (1,1,1,44,'5869baae-0321-11eb-9a46-0242ac110002');

-- Insert frame

INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status,fk_support)
VALUES (1,1,true,1,70cbdbbe-0320-11eb-9a46-0242ac110002);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1,70cbdbbe-0320-11eb-9a46-0242ac110002);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1,70cbdbbe-0320-11eb-9a46-0242ac110002);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1,70cc077e-0320-11eb-9a46-0242ac110002);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,1,70cc077e-0320-11eb-9a46-0242ac110002);
INSERT INTO siro_od.frame(fk_frame_type,fk_frame_fixing_type,double_sided,fk_status)
VALUES (1,1,true,70cc077e-0320-11eb-9a46-0242ac110002);
