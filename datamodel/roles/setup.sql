------------------------------------------
/* GRANT on schemas - once per database */
------------------------------------------

DO $$
DECLARE
    viewer_role text := :'viewer_role';
    user_role text := :'user_role';
BEGIN
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
