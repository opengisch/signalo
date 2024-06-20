--Disable triggers in signalo_db.sign before changes
ALTER TABLE signalo_db.sign DISABLE TRIGGER ALL;

DROP FUNCTION IF EXISTS signalo_db.ft_reorder_signs_in_frame();
DROP FUNCTION IF EXISTS signalo_db.ft_sign_prevent_fk_frame_update();
