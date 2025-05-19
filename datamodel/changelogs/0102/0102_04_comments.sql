-- add explanatory comments to selected columns in DB

-- support

COMMENT ON COLUMN signalo_db.support.fk_support_type
    IS 'Foreign key of support type value list';

COMMENT ON COLUMN signalo_db.support.fk_owner
    IS 'Foreign key of owner value list';

COMMENT ON COLUMN signalo_db.support.fk_provider
    IS 'Foreign key of provider value list';

COMMENT ON COLUMN signalo_db.support.fk_support_base_type
    IS 'Foreign key of support base type value list';

COMMENT ON COLUMN signalo_db.support.road_segment
    IS 'Optional field to reference a road';

COMMENT ON COLUMN signalo_db.support.height
    IS 'Support height';

COMMENT ON COLUMN signalo_db.support.height_free_under_signal
    IS 'Free height under signals';

COMMENT ON COLUMN signalo_db.support.fk_status
    IS 'Foreign key of status value list';

COMMENT ON COLUMN signalo_db.support.group_by_anchor
    IS 'Set true to visually order signals by their anchor point (within each azimut), set false if ranking order should be respected';

COMMENT ON COLUMN signalo_db.support.needs_validation
    IS 'Automatically set to true if the conditions for control are met';

COMMENT ON COLUMN signalo_db.support._creation_date
    IS 'Date of creation, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.support._creation_user
    IS 'User of creation, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.support._last_modification_date
    IS 'Date of last modification, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.support._last_modification_user
    IS 'User of last modification, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.support._last_modification_platform
    IS 'Platform (mobile, desktop) of last modification, automatically filled in within QGIS project.
    This field is used as a condition in the control view.';

COMMENT ON COLUMN signalo_db.support.usr_support_1
    IS 'Field for custom info; use can be specified with alias in QGIS';

COMMENT ON COLUMN signalo_db.support.usr_support_2
    IS 'Field for custom info; use can be specified with alias in QGIS';

COMMENT ON COLUMN signalo_db.support.usr_support_3
    IS 'Field for custom info; use can be specified with alias in QGIS';

-- azimut

COMMENT ON COLUMN signalo_db.azimut.fk_support
    IS 'Foreign key of associated support';

COMMENT ON COLUMN signalo_db.azimut._creation_date
    IS 'Date of creation, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.azimut._creation_user
    IS 'User of creation, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.azimut._last_modification_date
    IS 'Date of last modification, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.azimut._last_modification_user
    IS 'User of last modification, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.azimut._last_modification_platform
    IS 'Platform (mobile, desktop) of last modification, automatically filled in within QGIS project.
    This field is used as a condition in the control view.';

COMMENT ON COLUMN signalo_db.azimut.offset_x
    IS 'Sets an offset in X direction of all associated front side signals, to improve visibility on the map';

COMMENT ON COLUMN signalo_db.azimut.offset_y
    IS 'Sets an offset in Y direction of all associated frond side signals, to improve visibility on the map';

COMMENT ON COLUMN signalo_db.azimut.offset_x_verso
    IS 'Sets an offset in X direction of all associated back side signals, to improve visibility on the map';

COMMENT ON COLUMN signalo_db.azimut.offset_y_verso
    IS 'Sets an offset in Y direction of all associated back side signals, to improve visibility on the map';

COMMENT ON COLUMN signalo_db.azimut.needs_validation
    IS 'Automatically set to true if the conditions for control are met';

COMMENT ON COLUMN signalo_db.azimut.usr_azimut_1
    IS 'Field for custom info; use can be specified with alias in QGIS';

COMMENT ON COLUMN signalo_db.azimut.usr_azimut_2
    IS 'Field for custom info; use can be specified with alias in QGIS';

COMMENT ON COLUMN signalo_db.azimut.usr_azimut_3
    IS 'Field for custom info; use can be specified with alias in QGIS';

-- frame

COMMENT ON COLUMN signalo_db.frame.fk_azimut
    IS 'Foreign key of associated azimut';

COMMENT ON COLUMN signalo_db.frame.rank
    IS 'Ranking (automatically filled in in QGIS) depending on the order of frames for each azimut';

COMMENT ON COLUMN signalo_db.frame.fk_frame_type
    IS 'Foreign key for frame type value list';

COMMENT ON COLUMN signalo_db.frame.fk_frame_fixing_type
    IS 'Foreign key for frame fixing type value list';

COMMENT ON COLUMN signalo_db.frame.double_sided
    IS 'Set true if double sided (default). This has no influence on the symbology of the map';

COMMENT ON COLUMN signalo_db.frame.fk_status
    IS 'Foreign key of status value list';

COMMENT ON COLUMN signalo_db.frame.fk_provider
    IS 'Foreign key of provider value list';

COMMENT ON COLUMN signalo_db.frame.dimension_1
    IS 'If frame is rectangular, height/width; if frame is circular, radius; if frame is elliptic, major/minor radius';

COMMENT ON COLUMN signalo_db.frame.dimension_2
    IS 'If frame is rectangular, height/width; if frame is circular, not needed; if frame is elliptic, major/minor radius';

COMMENT ON COLUMN signalo_db.frame.anchor
    IS 'Anchor point of frame (left, right, center). Default is center. This value influences the visual representation on the map and is used in support.group_by_anchor condition';

-- sign

COMMENT ON COLUMN signalo_db.sign.fk_frame
    IS 'Foreign key of associated frame';

COMMENT ON COLUMN signalo_db.sign.rank
    IS 'Ranking (automatically filled in in QGIS) depending on the order of signs for each frame';

COMMENT ON COLUMN signalo_db.sign.complex
    IS 'Set true if the sign is too complex for being in the available svg selection. A placeholder sign ("?") will appear on the map, the real sign can be seen on the photo in the form';

COMMENT ON COLUMN signalo_db.sign.fk_sign_type
    IS 'Foreign key of sign type value list';

COMMENT ON COLUMN signalo_db.sign.fk_official_sign
    IS 'Foreign key of official sign value list';

COMMENT ON COLUMN signalo_db.sign.fk_marker_type
    IS 'Foreign key of marker type value list';

COMMENT ON COLUMN signalo_db.sign.fk_mirror_shape
    IS 'Foreign key of mirror shape value list';

COMMENT ON COLUMN signalo_db.sign.fk_parent
    IS 'Foreign key of associated parent sign';

COMMENT ON COLUMN signalo_db.sign.fk_owner
    IS 'Foreign key of owner value list';

COMMENT ON COLUMN signalo_db.sign.fk_provider
    IS 'Foreign key of provider value list';

COMMENT ON COLUMN signalo_db.sign.fk_durability
    IS 'Foreign key of durability value list';

COMMENT ON COLUMN signalo_db.sign.fk_status
    IS 'Foreign key of status value list';

COMMENT ON COLUMN signalo_db.sign.case_id
    IS 'Identifier of offical autorisation case';

COMMENT ON COLUMN signalo_db.sign.case_decision
    IS 'Decision of offical autorisation case';

COMMENT ON COLUMN signalo_db.sign.inscription_1
    IS 'Line 1 for dynamic inscriptions';

COMMENT ON COLUMN signalo_db.sign.inscription_2
    IS 'Line 2 for dynamic inscriptions';

COMMENT ON COLUMN signalo_db.sign.inscription_3
    IS 'Line 3 for dynamic inscriptions';

COMMENT ON COLUMN signalo_db.sign.fk_coating
    IS 'Foreign key of coating value list';

COMMENT ON COLUMN signalo_db.sign.fk_lighting
    IS 'Foreign key of lighting value list';

COMMENT ON COLUMN signalo_db.sign.mirror_protruding
    IS 'boolean (default is false)';

COMMENT ON COLUMN signalo_db.sign.mirror_red_frame
    IS 'boolean (default is false)';

COMMENT ON COLUMN signalo_db.sign.dimension_1
    IS 'If sign is rectangular, height/width; if sign is circular, radius; if sign is elliptic, major/minor radius';

COMMENT ON COLUMN signalo_db.sign.dimension_2
    IS 'If sign is rectangular, height/width; if sign is circular, not needed; if sign is elliptic, major/minor radius';

COMMENT ON COLUMN signalo_db.sign.fk_user_sign
    IS 'Foreign key of user sign value list';

COMMENT ON COLUMN signalo_db.sign.natural_direction_or_left
    IS 'Determines the direction for directional signs, with reference to frame.anchor. Default is true';

COMMENT ON COLUMN signalo_db.sign.hanging_mode
    IS 'Defines whether a panel carries the same signal on both sides; influences the symbology on the map. Default is recto (only front side)';

COMMENT ON COLUMN signalo_db.sign._creation_date
    IS 'Date of creation, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.sign._creation_user
    IS 'User of creation, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.sign._last_modification_date
    IS 'Date of last modification, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.sign._last_modification_user
    IS 'User of last modification, automatically filled in within QGIS project';

COMMENT ON COLUMN signalo_db.sign._last_modification_platform
    IS 'Platform (mobile, desktop) of last modification, automatically filled in within QGIS project.
    This field is used as a condition in the control view.';

COMMENT ON COLUMN signalo_db.sign.needs_validation
    IS 'Automatically set to true if the conditions for control are met';

COMMENT ON COLUMN signalo_db.sign.usr_sign_1
    IS 'Field for custom info; use can be specified with alias in QGIS';

COMMENT ON COLUMN signalo_db.sign.usr_sign_2
    IS 'Field for custom info; use can be specified with alias in QGIS';

COMMENT ON COLUMN signalo_db.sign.usr_sign_3
    IS 'Field for custom info; use can be specified with alias in QGIS';

-- vl_official_sign

COMMENT ON COLUMN signalo_db.vl_official_sign.active
    IS 'Set to false if sign should not appear in the selection anymore. Default is true';

COMMENT ON COLUMN signalo_db.vl_official_sign.img_de
    IS 'Path to svg (if directional, this is the left direction). Idem for img_fr, img_it, img_ro';

COMMENT ON COLUMN signalo_db.vl_official_sign.img_height
    IS 'Height of the svg. If 0, it will not appear on the map. Ratio width-height has to be respected';

COMMENT ON COLUMN signalo_db.vl_official_sign.img_width
    IS 'Width of the svg. If 0, it will not appear on the map. Ratio width-height has to be respected';

COMMENT ON COLUMN signalo_db.vl_official_sign.no_dynamic_inscription
    IS 'Number of dynamic inscriptions. Default is 0';

COMMENT ON COLUMN signalo_db.vl_official_sign.directional_sign
    IS 'Boolean if sign is directional. Default is false';

COMMENT ON COLUMN signalo_db.vl_official_sign.img_de_right
    IS 'Path to svg (if directional, this is the right direction). Idem for img_fr_right, img_it_right, img_ro_right';

-- vl_official_sign

COMMENT ON COLUMN signalo_db.vl_official_sign.active
    IS 'Set to false if sign should not appear in the selection anymore. Default is true';

COMMENT ON COLUMN signalo_db.vl_official_sign.img_de
    IS 'Path to svg (if directional, this is the left direction). Idem for img_fr, img_it, img_ro';

-- vl_user_sign

COMMENT ON COLUMN signalo_db.vl_user_sign.img_height
    IS 'Height of the svg. If 0, it will not appear on the map. Ratio width-height has to be respected';

COMMENT ON COLUMN signalo_db.vl_user_sign.img_width
    IS 'Width of the svg. If 0, it will not appear on the map. Ratio width-height has to be respected';

COMMENT ON COLUMN signalo_db.vl_user_sign.no_dynamic_inscription
    IS 'Number of dynamic inscriptions. Default is 0';

COMMENT ON COLUMN signalo_db.vl_user_sign.directional_sign
    IS 'Boolean if sign is directional. Default is false';

COMMENT ON COLUMN signalo_db.vl_user_sign.img_de_right
    IS 'Path to svg (if directional, this is the right direction). Idem for img_fr_right, img_it_right, img_ro_right';


-- dms_document

COMMENT ON COLUMN signalo_db.dms_document.identification
    IS 'Name or description of the document';

COMMENT ON COLUMN signalo_db.dms_document.path
    IS 'Path to the document';

COMMENT ON COLUMN signalo_db.dms_document.type
    IS 'Type (jpg, png, pdf, image, document, etc.)';


-- dms_rel_document

COMMENT ON COLUMN signalo_db.dms_rel_document.fk_document
    IS 'Foreign key of document; automatically filled in';

COMMENT ON COLUMN signalo_db.dms_rel_document.fk_object
    IS 'Foreign key of associated object (azimut or support); automatically filled in';

COMMENT ON COLUMN signalo_db.dms_rel_document.object_class
    IS 'Type of associated object: azimut or support; automatically filled in';
