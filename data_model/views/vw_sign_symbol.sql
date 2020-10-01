
CREATE OR REPLACE VIEW siro_od.vw_sign_symbol AS

--SELECT
--    sign.*,
--    support.geometry
--FROM siro_od.sign
--LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
--LEFT JOIN siro_od.support ON support.id = frame.fk_support

SELECT
    az_group.azimut,
    sign.id,
    frame.rank AS frame_rank,
    sign.rank AS sign_rank,
    sign.fk_official_sign,
    ROW_NUMBER () OVER (
    PARTITION BY az_group.azimut
    ) AS final_rank
FROM siro_od.sign
LEFT JOIN siro_od.frame ON frame.id = sign.fk_frame
LEFT JOIN siro_od.support ON support.id = frame.fk_support
LEFT JOIN generate_series(-5,355,10) az_group (azimut)
    ON sign.azimut >= az_group.azimut
    AND sign.azimut < az_group.azimut + 10
ORDER BY azimut, final_rank;