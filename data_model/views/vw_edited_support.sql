CREATE OR REPLACE VIEW signalo_od.vw_edited_support AS
    SELECT su.id, su.geometry,
        greatest(su._last_modified_date, a._last_modified_date, f._last_modified_date, si._last_modified_date) AS _last_modified_date
    FROM signalo_od.support su
    LEFT JOIN LATERAL (SELECT id, fk_support, MAX(_last_modified_date) OVER (PARTITION BY fk_support) AS _last_modified_date FROM signalo_od.azimut ) a ON a.fk_support = su.id
    LEFT JOIN LATERAL (SELECT id, fk_azimut, MAX(_last_modified_date) OVER (PARTITION BY fk_azimut) AS _last_modified_date FROM signalo_od.frame) f ON f.fk_azimut = a.id
    LEFT JOIN LATERAL (SELECT id, fk_frame, MAX(_last_modified_date) OVER (PARTITION BY fk_frame) AS _last_modified_date FROM signalo_od.sign) si ON si.fk_frame = f.id;
