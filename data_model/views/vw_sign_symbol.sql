CREATE OR REPLACE VIEW siro_od.vw_sign_symbol AS
SELECT sign.*, support.geometry
FROM siro_od.sign
LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
LEFT JOIN siro_od.support ON support.id = frame.fk_support