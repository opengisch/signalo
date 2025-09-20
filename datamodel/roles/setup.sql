------------------------------------------
/* GRANT on schemas - once per database */
------------------------------------------

DO $$
DECLARE
    viewer_role text := :'signalor_viewer';
    user_role text := :'signalo_user';
BEGIN
SELECT format('REVOKE CONNECT ON DATABASE %I FROM myuser;', datname)
FROM pg_database
WHERE datname NOT IN ('appdb');


    FOR datname IN SELECT datname FROM pg_database
        WHERE datname NOT IN ('signalo_testing', 'signalo_stable')
    LOOP
        EXECUTE format('REVOKE CONNECT ON DATABASE %I FROM %I', datname, viewer_role);
    END LOOP;
    EXECUTE format('GRANT CONNECT ON DATABASE %I TO %I', db_name, viewer_role);

    EXECUTE format('GRANT USAGE ON SCHEMA signalo_db TO %I', viewer_role);
    EXECUTE format('GRANT USAGE ON SCHEMA signalo_app TO %I', viewer_role);
    EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA signalo_db TO %I', viewer_role);
    EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA signalo_app TO %I', viewer_role);
    EXECUTE format('GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA signalo_db TO %I', viewer_role);
    EXECUTE format('GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA signalo_app TO %I', viewer_role);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_db GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO %I', viewer_role);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_app GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO %I', viewer_role);

    EXECUTE format('GRANT ALL ON SCHEMA signalo_db TO %I', user_role);
    EXECUTE format('GRANT ALL ON ALL TABLES IN SCHEMA signalo_db TO %I', user_role);
    EXECUTE format('GRANT ALL ON ALL SEQUENCES IN SCHEMA signalo_db TO %I', user_role);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_db GRANT ALL ON TABLES TO %I', user_role);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_db GRANT ALL ON SEQUENCES TO %I', user_role);
    EXECUTE format('GRANT ALL ON SCHEMA signalo_app TO %I', user_role);
    EXECUTE format('GRANT ALL ON ALL TABLES IN SCHEMA signalo_app TO %I', user_role);
    EXECUTE format('GRANT ALL ON ALL SEQUENCES IN SCHEMA signalo_app TO %I', user_role);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_app GRANT ALL ON TABLES TO %I', user_role);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA signalo_app GRANT ALL ON SEQUENCES TO %I', user_role);
END
$$;
