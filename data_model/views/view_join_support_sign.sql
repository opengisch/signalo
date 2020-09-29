CREATE OR REPLACE VIEW view_support_sign_join AS
SELECT sign.*, support.geometry
FROM siro_od.sign
LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
LEFT JOIN siro_od.support ON support.id = frame.fk_support