-- Trigger in signalo_db.sign before changes
DROP TRIGGER IF EXISTS tr_sign_on_delete_reorder ON signalo_db.sign;
DROP TRIGGER IF EXISTS tr_sign_on_update_prevent_fk_frame ON signalo_db.sign;
DROP FUNCTION IF EXISTS signalo_db.ft_reorder_signs_in_frame();
DROP FUNCTION IF EXISTS signalo_db.ft_sign_prevent_fk_frame_update();
