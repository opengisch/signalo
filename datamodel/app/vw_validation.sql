CREATE OR REPLACE VIEW signalo_app.vw_validation AS
    SELECT
        DISTINCT ON (su.id)
        su.id,
        su.geometry,
        greatest(su._last_modification_date, a._last_modification_date, f._last_modification_date, si._last_modification_date) AS last_modification_date,
        su.needs_validation or a.needs_validation or f.needs_validation or si.needs_validation AS needs_validation
    FROM signalo_db.support su
    LEFT JOIN (SELECT id, fk_support, needs_validation, MAX(_last_modification_date) OVER (PARTITION BY fk_support) AS _last_modification_date FROM signalo_db.azimut ) a ON a.fk_support = su.id
    LEFT JOIN (SELECT id, fk_azimut, needs_validation, MAX(_last_modification_date) OVER (PARTITION BY fk_azimut) AS _last_modification_date FROM signalo_db.frame) f ON f.fk_azimut = a.id
    LEFT JOIN (SELECT id, fk_frame, needs_validation, MAX(_last_modification_date) OVER (PARTITION BY fk_frame) AS _last_modification_date FROM signalo_db.sign) si ON si.fk_frame = f.id;
