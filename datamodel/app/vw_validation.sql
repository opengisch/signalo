CREATE OR REPLACE VIEW signalo_app.vw_validation AS
    SELECT
        DISTINCT ON (su.id)
        su.id,
        su.geometry,
        greatest(su._last_modification_date, a._last_modification_date, f._last_modification_date, si._last_modification_date) AS last_modification_date,
        su.needs_validation or a.needs_validation or f.needs_validation or si.needs_validation AS needs_validation,
        su.needs_validation AS support_needs_validation,
        (
            SELECT array_agg(a.id)
            FROM signalo_db.azimut a
            WHERE a.fk_support = su.id AND a.needs_validation = TRUE
            ORDER BY a.id
        ) AS azimuts_need_validation,
        (
            SELECT array_agg(f.id)
            FROM signalo_db.frame f
            JOIN signalo_db.azimut a ON f.fk_azimut = a.id
            WHERE a.fk_support = su.id AND f.needs_validation = TRUE
            ORDER BY f.id
        ) AS frames_need_validation,
        (
            SELECT array_agg(sgn.id)
            FROM signalo_db.sign sgn
            JOIN signalo_db.frame f ON sgn.fk_frame = f.id
            JOIN signalo_db.azimut a ON f.fk_azimut = a.id
            WHERE a.fk_support = su.id AND sgn.needs_validation = TRUE
            ORDER BY sgn.id
        ) AS signs_need_validation
    FROM signalo_db.support su
    LEFT JOIN (SELECT id, fk_support, needs_validation, MAX(_last_modification_date) OVER (PARTITION BY fk_support ORDER BY needs_validation DESC NULLS LAST) AS _last_modification_date FROM signalo_db.azimut ) a ON a.fk_support = su.id
    LEFT JOIN (SELECT id, fk_azimut, needs_validation, MAX(_last_modification_date) OVER (PARTITION BY fk_azimut ORDER BY needs_validation DESC NULLS LAST) AS _last_modification_date FROM signalo_db.frame) f ON f.fk_azimut = a.id
    LEFT JOIN (SELECT id, fk_frame, needs_validation, MAX(_last_modification_date) OVER (PARTITION BY fk_frame ORDER BY needs_validation DESC NULLS LAST) AS _last_modification_date FROM signalo_db.sign) si ON si.fk_frame = f.id;

CREATE FUNCTION signalo_app.ft_validation_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE signalo_db.support SET needs_validation = NEW.needs_validation WHERE id = NEW.id;
        UPDATE signalo_db.azimut SET needs_validation = NEW.needs_validation WHERE fk_support = NEW.id;
        UPDATE signalo_db.frame fr SET needs_validation = NEW.needs_validation FROM signalo_db.azimut az WHERE fr.fk_azimut = az.id AND az.fk_support = NEW.id;
        UPDATE signalo_db.sign si SET needs_validation = NEW.needs_validation FROM signalo_db.frame fr, signalo_db.azimut az WHERE si.fk_frame = fr.id AND fr.fk_azimut = az.id AND az.fk_support = NEW.id;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER azimut_update
    INSTEAD OF UPDATE ON signalo_app.vw_validation
    FOR EACH ROW
    EXECUTE FUNCTION signalo_app.ft_validation_update();
