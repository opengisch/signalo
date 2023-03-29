

ALTER TABLE signalo_db.vl_durability ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_durability ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_durability ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_frame_fixing_type ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_frame_fixing_type ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_frame_fixing_type ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_frame_type ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_frame_type ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_frame_type ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_lighting ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_lighting ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_lighting ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_marker_type DROP COLUMN value_it;
ALTER TABLE signalo_db.vl_marker_type DROP COLUMN value_ro;
ALTER TABLE signalo_db.vl_marker_type ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_marker_type ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_marker_type ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_mirror_shape DROP COLUMN value_it;
ALTER TABLE signalo_db.vl_mirror_shape DROP COLUMN value_ro;
ALTER TABLE signalo_db.vl_mirror_shape ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_mirror_shape ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_mirror_shape ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_sign_type DROP COLUMN value_it;
ALTER TABLE signalo_db.vl_sign_type DROP COLUMN value_ro;
ALTER TABLE signalo_db.vl_sign_type ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_sign_type ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_sign_type ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_status ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_status ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_status ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_support_type ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_support_type ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_support_type ADD COLUMN description_de text;

ALTER TABLE signalo_db.vl_support_base_type ADD COLUMN description_en text;
ALTER TABLE signalo_db.vl_support_base_type ADD COLUMN description_fr text;
ALTER TABLE signalo_db.vl_support_base_type ADD COLUMN description_de text;
