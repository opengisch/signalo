------------------------------------------
/* GRANT on schemas - once per database */
------------------------------------------

DO $$
DECLARE
    db_name text := current_setting('db_name');
BEGIN
    SELECT format('REVOKE CONNECT ON DATABASE %I FROM myuser;', datname)
    FROM pg_database
    WHERE datname NOT IN ('appdb');

    FOR datname IN SELECT datname FROM pg_database
    LOOP
        EXECUTE format('REVOKE CONNECT ON DATABASE %I FROM signalo_viewer', datname);
    END LOOP;
    EXECUTE format('GRANT CONNECT ON DATABASE %I TO signalo_viewer', db_name);

    GRANT USAGE ON SCHEMA signalo_db TO signalo_viewer;
    GRANT USAGE ON SCHEMA signalo_app TO signalo_viewer;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA signalo_db TO signalo_viewer;
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA signalo_app TO signalo_viewer;
    GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA signalo_db TO signalo_viewer;
    GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA signalo_app TO signalo_viewer;
    ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_db GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO signalo_viewer;
    ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_app GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO signalo_viewer;

    GRANT ALL ON SCHEMA signalo_db TO signalo_user;
    GRANT ALL ON ALL TABLES IN SCHEMA signalo_db TO signalo_user;
    GRANT ALL ON ALL SEQUENCES IN SCHEMA signalo_db TO signalo_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_db GRANT ALL ON TABLES TO signalo_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_db GRANT ALL ON SEQUENCES TO signalo_user;
    GRANT ALL ON SCHEMA signalo_app TO signalo_user;
    GRANT ALL ON ALL TABLES IN SCHEMA signalo_app TO signalo_user;
    GRANT ALL ON ALL SEQUENCES IN SCHEMA signalo_app TO signalo_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_app GRANT ALL ON TABLES TO signalo_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_app GRANT ALL ON SEQUENCES TO signalo_user;
END
$$;
