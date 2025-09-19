DO $$
DECLARE
    viewer_role text := :'viewer_role';
    user_role text := :'user_role';
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = viewer_role) THEN
        EXECUTE format('CREATE ROLE %I NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION', viewer_role);
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = user_role) THEN
        EXECUTE format('CREATE ROLE %I NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION', user_role);
    END IF;

    EXECUTE format('GRANT %I TO %I', viewer_role, user_role);
END
$$;
