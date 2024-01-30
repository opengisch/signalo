

CREATE OR REPLACE VIEW signalo_app.vw_azimut_edit
AS
SELECT
  az.id,
  ST_MakeLine(su.geometry, ST_SetSRID(St_MakePoint(ST_X(su.geometry) + 10 * sin(radians(az.azimut)), ST_Y(su.geometry) + 10 *cos(radians(az.azimut))), 2056))::geometry(LineString, 2056) as geometry
FROM signalo_db.azimut az
INNER JOIN signalo_db.support su ON az.fk_support = su.id;


CREATE FUNCTION signalo_app.ft_azimut_edit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
        IF ST_Equals(ST_StartPoint(NEW.geometry), ST_StartPoint(OLD.geometry)) THEN
            RAISE WARNING 'start point should remain unchanged';
        END IF;

        UPDATE signalo_db.azimut SET azimut = degrees(ST_Azimuth(ST_StartPoint(NEW.geometry), ST_EndPoint(NEW.geometry))) WHERE id = NEW.id;

        RETURN NEW;
	END;
	$$;


CREATE TRIGGER azimut_update
    INSTEAD OF UPDATE ON signalo_app.vw_azimut_edit
    FOR EACH ROW
    EXECUTE FUNCTION signalo_app.ft_azimut_edit();
