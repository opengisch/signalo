

CREATE OR REPLACE VIEW signalo_app.vw_azimut_edit
AS
SELECT
  az.id,
  ST_MakeLine(su.geometry, ST_SetSRID(St_MakePoint(ST_X(su.geometry) + 10 * sin(radians(az.azimut)), ST_Y(su.geometry) + 10 *cos(radians(az.azimut))), 2056))::geometry(LineString, 2056) as geometry
FROM signalo_db.azimut az
INNER JOIN signalo_db.support su ON az.fk_support = su.id;


CREATE FUNCTION signalo_app.ft_azimut_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
        support_id uuid := NULL;
    BEGIN
        IF ST_NumPoints(NEW.geometry) != 2 THEN
            RAISE EXCEPTION 'The line should have only 2 vertices';
        END IF;
        SELECT id FROM signalo_db.support s WHERE ST_Equals(s.geometry, ST_StartPoint(NEW.geometry)) INTO support_id;
        IF support_id IS NULL THEN
            INSERT INTO signalo_db.support (geometry) VALUES (ST_StartPoint(NEW.geometry)) RETURNING id INTO support_id;
            IF support_id IS NULL THEN
                RAISE EXCEPTION 'Could not create a support';
            END IF;
        END IF;
        INSERT INTO signalo_db.azimut (fk_support, azimut) VALUES (support_id, degrees(ST_Azimuth(ST_StartPoint(NEW.geometry), ST_EndPoint(NEW.geometry))));
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER azimut_insert
    INSTEAD OF INSERT ON signalo_app.vw_azimut_edit
    FOR EACH ROW
    EXECUTE FUNCTION signalo_app.ft_azimut_insert();




CREATE FUNCTION signalo_app.ft_azimut_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF NOT ST_Equals(ST_StartPoint(NEW.geometry), ST_StartPoint(OLD.geometry)) THEN
            RAISE EXCEPTION 'Start point should remain unchanged';
        END IF;
        IF ST_NumPoints(NEW.geometry) != 2 THEN
            RAISE EXCEPTION 'The line should have only 2 vertices';
        END IF;
        UPDATE signalo_db.azimut SET azimut = degrees(ST_Azimuth(ST_StartPoint(NEW.geometry), ST_EndPoint(NEW.geometry))) WHERE id = NEW.id;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER azimut_update
    INSTEAD OF UPDATE ON signalo_app.vw_azimut_edit
    FOR EACH ROW
    EXECUTE FUNCTION signalo_app.ft_azimut_update();
