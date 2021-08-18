--
-- PostgreSQL database dump
--

-- Dumped from database version 11.10 (Debian 11.10-1.pgdg90+1)
-- Dumped by pg_dump version 11.10 (Debian 11.10-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: signalo_od; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA signalo_od;


ALTER SCHEMA signalo_od OWNER TO postgres;

--
-- Name: signalo_vl; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA signalo_vl;


ALTER SCHEMA signalo_vl OWNER TO postgres;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: ft_reorder_frames_on_support(); Type: FUNCTION; Schema: signalo_od; Owner: postgres
--

CREATE FUNCTION signalo_od.ft_reorder_frames_on_support() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
	    _rank integer := 1;
	    _frame record;
	BEGIN
        FOR _frame IN (SELECT * FROM signalo_od.frame WHERE fk_azimut = OLD.fk_azimut ORDER BY rank ASC)
        LOOP
            UPDATE signalo_od.frame SET rank = _rank WHERE id = _frame.id;
            _rank = _rank + 1;
        END LOOP;
		RETURN OLD;
	END;
	$$;


ALTER FUNCTION signalo_od.ft_reorder_frames_on_support() OWNER TO postgres;

--
-- Name: ft_reorder_frames_on_support_put_last(); Type: FUNCTION; Schema: signalo_od; Owner: postgres
--

CREATE FUNCTION signalo_od.ft_reorder_frames_on_support_put_last() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
	    NEW.rank := (SELECT MAX(rank)+1 FROM signalo_od.frame WHERE fk_azimut = NEW.fk_azimut);
		RETURN NEW;
	END;
	$$;


ALTER FUNCTION signalo_od.ft_reorder_frames_on_support_put_last() OWNER TO postgres;

--
-- Name: ft_reorder_signs_in_frame(); Type: FUNCTION; Schema: signalo_od; Owner: postgres
--

CREATE FUNCTION signalo_od.ft_reorder_signs_in_frame() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
	    _rank integer := 1;
	    _sign record;
	BEGIN
        FOR _sign IN (SELECT * FROM signalo_od.sign WHERE fk_frame = OLD.fk_frame ORDER BY rank ASC)
        LOOP
            UPDATE signalo_od.sign SET rank = _rank WHERE id = _sign.id;
            _rank = _rank + 1;
        END LOOP;
		RETURN OLD;
	END;
	$$;


ALTER FUNCTION signalo_od.ft_reorder_signs_in_frame() OWNER TO postgres;

--
-- Name: ft_sign_prevent_fk_frame_update(); Type: FUNCTION; Schema: signalo_od; Owner: postgres
--

CREATE FUNCTION signalo_od.ft_sign_prevent_fk_frame_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      RAISE EXCEPTION 'A sign cannot be reassigned to another frame.';
    END;
    $$;


ALTER FUNCTION signalo_od.ft_sign_prevent_fk_frame_update() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: azimut; Type: TABLE; Schema: signalo_od; Owner: postgres
--

CREATE TABLE signalo_od.azimut (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    fk_support uuid NOT NULL,
    azimut smallint DEFAULT 0,
    usr_azimut_1 text,
    usr_azimut_2 text,
    usr_azimut_3 text,
    _inserted_date timestamp without time zone DEFAULT now(),
    _inserted_user text,
    _last_modified_date timestamp without time zone DEFAULT now(),
    _last_modified_user text,
    _edited boolean DEFAULT false
);


ALTER TABLE signalo_od.azimut OWNER TO postgres;

--
-- Name: frame; Type: TABLE; Schema: signalo_od; Owner: postgres
--

CREATE TABLE signalo_od.frame (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    fk_azimut uuid NOT NULL,
    rank integer DEFAULT 1 NOT NULL,
    fk_frame_type integer,
    fk_frame_fixing_type integer,
    double_sided boolean DEFAULT true,
    fk_status integer,
    fk_provider uuid,
    comment text,
    picture text,
    dimension_1 numeric(7,2),
    dimension_2 numeric(7,2),
    usr_frame_1 text,
    usr_frame_2 text,
    usr_frame_3 text,
    _inserted_date timestamp without time zone DEFAULT now(),
    _inserted_user text,
    _last_modified_date timestamp without time zone DEFAULT now(),
    _last_modified_user text,
    _edited boolean DEFAULT false
);


ALTER TABLE signalo_od.frame OWNER TO postgres;

--
-- Name: owner; Type: TABLE; Schema: signalo_od; Owner: postgres
--

CREATE TABLE signalo_od.owner (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    active boolean DEFAULT true,
    name text,
    usr_owner_1 text,
    usr_owner_2 text,
    usr_owner_3 text,
    _inserted_date timestamp without time zone DEFAULT now(),
    _inserted_user text,
    _last_modified_date timestamp without time zone DEFAULT now(),
    _last_modified_user text
);


ALTER TABLE signalo_od.owner OWNER TO postgres;

--
-- Name: provider; Type: TABLE; Schema: signalo_od; Owner: postgres
--

CREATE TABLE signalo_od.provider (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    active boolean DEFAULT true,
    name text,
    usr_provider_1 text,
    usr_provider_2 text,
    usr_provider_3 text,
    _inserted_date timestamp without time zone DEFAULT now(),
    _inserted_user text,
    _last_modified_date timestamp without time zone DEFAULT now(),
    _last_modified_user text
);


ALTER TABLE signalo_od.provider OWNER TO postgres;

--
-- Name: sign; Type: TABLE; Schema: signalo_od; Owner: postgres
--

CREATE TABLE signalo_od.sign (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    fk_frame uuid NOT NULL,
    rank integer DEFAULT 1 NOT NULL,
    verso boolean DEFAULT false NOT NULL,
    complex boolean DEFAULT false NOT NULL,
    fk_sign_type integer NOT NULL,
    fk_official_sign text,
    fk_marker_type integer,
    fk_mirror_shape integer,
    fk_parent uuid,
    fk_owner uuid,
    fk_provider uuid,
    fk_durability integer,
    fk_status integer,
    installation_date date,
    manufacturing_date date,
    case_id text,
    case_decision text,
    inscription_1 text,
    inscription_2 text,
    inscription_3 text,
    fk_coating integer,
    fk_lighting integer,
    comment text,
    picture text,
    mirror_protruding boolean DEFAULT false,
    mirror_red_frame boolean DEFAULT false,
    dimension_1 numeric(7,2),
    dimension_2 numeric(7,2),
    usr_sign_1 text,
    usr_sign_2 text,
    usr_sign_3 text,
    _inserted_date timestamp without time zone DEFAULT now(),
    _inserted_user text,
    _last_modified_date timestamp without time zone DEFAULT now(),
    _last_modified_user text,
    _edited boolean DEFAULT false
);


ALTER TABLE signalo_od.sign OWNER TO postgres;

--
-- Name: support; Type: TABLE; Schema: signalo_od; Owner: postgres
--

CREATE TABLE signalo_od.support (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    address text,
    fk_support_type integer,
    fk_owner uuid,
    fk_provider uuid,
    fk_support_base_type integer,
    road_segment text,
    height numeric(8,3),
    height_free_under_signal numeric(8,3),
    date_install date,
    date_last_stability_check date,
    fk_status integer,
    comment text,
    picture text,
    geometry public.geometry(Point,:SRID) NOT NULL,
    usr_support_1 text,
    usr_support_2 text,
    usr_support_3 text,
    _inserted_date timestamp without time zone DEFAULT now(),
    _inserted_user text,
    _last_modified_date timestamp without time zone DEFAULT now(),
    _last_modified_user text,
    _edited boolean DEFAULT false
);


ALTER TABLE signalo_od.support OWNER TO postgres;

--
-- Name: coating; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.coating (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_en text,
    value_fr text,
    value_de text,
    description_en text,
    description_fr text,
    description_de text
);


ALTER TABLE signalo_vl.coating OWNER TO postgres;

--
-- Name: coating_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.coating ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.coating_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: durability; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.durability (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_en text,
    value_fr text,
    value_de text
);


ALTER TABLE signalo_vl.durability OWNER TO postgres;

--
-- Name: durability_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.durability ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.durability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: frame_fixing_type; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.frame_fixing_type (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_en text,
    value_fr text,
    value_de text
);


ALTER TABLE signalo_vl.frame_fixing_type OWNER TO postgres;

--
-- Name: frame_fixing_type_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.frame_fixing_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.frame_fixing_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: frame_type; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.frame_type (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_en text,
    value_fr text,
    value_de text
);


ALTER TABLE signalo_vl.frame_type OWNER TO postgres;

--
-- Name: frame_type_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.frame_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.frame_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lighting; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.lighting (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_en text,
    value_fr text,
    value_de text
);


ALTER TABLE signalo_vl.lighting OWNER TO postgres;

--
-- Name: lighting_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.lighting ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.lighting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: marker_type; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.marker_type (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_de text,
    value_fr text,
    value_it text,
    value_ro text
);


ALTER TABLE signalo_vl.marker_type OWNER TO postgres;

--
-- Name: marker_type_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.marker_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.marker_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: mirror_shape; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.mirror_shape (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_de text,
    value_fr text,
    value_it text,
    value_ro text
);


ALTER TABLE signalo_vl.mirror_shape OWNER TO postgres;

--
-- Name: mirror_shape_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.mirror_shape ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.mirror_shape_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: official_sign; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.official_sign (
    id text NOT NULL,
    active boolean DEFAULT true,
    value_de text,
    value_fr text,
    value_it text,
    value_ro text,
    description_de text,
    description_fr text,
    description_it text,
    description_ro text,
    img_de text,
    img_fr text,
    img_it text,
    img_ro text,
    img_height integer DEFAULT 100,
    img_width integer DEFAULT 100,
    no_dynamic_inscription integer DEFAULT 0,
    default_inscription1 text,
    default_inscription2 text,
    default_inscription3 text,
    default_inscription4 text
);


ALTER TABLE signalo_vl.official_sign OWNER TO postgres;

--
-- Name: sign_type; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.sign_type (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_de text,
    value_fr text,
    value_it text,
    value_ro text
);


ALTER TABLE signalo_vl.sign_type OWNER TO postgres;

--
-- Name: sign_type_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.sign_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.sign_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: status; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.status (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_en text,
    value_fr text,
    value_de text
);


ALTER TABLE signalo_vl.status OWNER TO postgres;

--
-- Name: status_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.status ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: support_base_type; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.support_base_type (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_en text,
    value_fr text,
    value_de text
);


ALTER TABLE signalo_vl.support_base_type OWNER TO postgres;

--
-- Name: support_base_type_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.support_base_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.support_base_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: support_type; Type: TABLE; Schema: signalo_vl; Owner: postgres
--

CREATE TABLE signalo_vl.support_type (
    id integer NOT NULL,
    active boolean DEFAULT true,
    value_en text,
    value_fr text,
    value_de text
);


ALTER TABLE signalo_vl.support_type OWNER TO postgres;

--
-- Name: support_type_id_seq; Type: SEQUENCE; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE signalo_vl.support_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME signalo_vl.support_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: azimut; Type: TABLE DATA; Schema: signalo_od; Owner: postgres
--



--
-- Data for Name: frame; Type: TABLE DATA; Schema: signalo_od; Owner: postgres
--



--
-- Data for Name: owner; Type: TABLE DATA; Schema: signalo_od; Owner: postgres
--

INSERT INTO signalo_od.owner (id, active, name, usr_owner_1, usr_owner_2, usr_owner_3, _inserted_date, _inserted_user, _last_modified_date, _last_modified_user) VALUES ('f5720bd2-ff36-11eb-9927-0242ac110002', true, 'Commune', NULL, NULL, NULL, '2021-08-17 08:41:47.612574', NULL, '2021-08-17 08:41:47.612574', NULL);
INSERT INTO signalo_od.owner (id, active, name, usr_owner_1, usr_owner_2, usr_owner_3, _inserted_date, _inserted_user, _last_modified_date, _last_modified_user) VALUES ('f5725a2e-ff36-11eb-9927-0242ac110002', true, 'Canton', NULL, NULL, NULL, '2021-08-17 08:41:47.615352', NULL, '2021-08-17 08:41:47.615352', NULL);
INSERT INTO signalo_od.owner (id, active, name, usr_owner_1, usr_owner_2, usr_owner_3, _inserted_date, _inserted_user, _last_modified_date, _last_modified_user) VALUES ('f5729f34-ff36-11eb-9927-0242ac110002', true, 'Confédération', NULL, NULL, NULL, '2021-08-17 08:41:47.617519', NULL, '2021-08-17 08:41:47.617519', NULL);
INSERT INTO signalo_od.owner (id, active, name, usr_owner_1, usr_owner_2, usr_owner_3, _inserted_date, _inserted_user, _last_modified_date, _last_modified_user) VALUES ('f572dd14-ff36-11eb-9927-0242ac110002', true, 'Privé', NULL, NULL, NULL, '2021-08-17 08:41:47.619238', NULL, '2021-08-17 08:41:47.619238', NULL);


--
-- Data for Name: provider; Type: TABLE DATA; Schema: signalo_od; Owner: postgres
--

INSERT INTO signalo_od.provider (id, active, name, usr_provider_1, usr_provider_2, usr_provider_3, _inserted_date, _inserted_user, _last_modified_date, _last_modified_user) VALUES ('f58a8cca-ff36-11eb-99e5-0242ac110002', true, 'L. Ellgass SA', NULL, NULL, NULL, '2021-08-17 08:41:47.773303', NULL, '2021-08-17 08:41:47.773303', NULL);
INSERT INTO signalo_od.provider (id, active, name, usr_provider_1, usr_provider_2, usr_provider_3, _inserted_date, _inserted_user, _last_modified_date, _last_modified_user) VALUES ('f58ac1ea-ff36-11eb-99e5-0242ac110002', true, 'Signal SA', NULL, NULL, NULL, '2021-08-17 08:41:47.775707', NULL, '2021-08-17 08:41:47.775707', NULL);
INSERT INTO signalo_od.provider (id, active, name, usr_provider_1, usr_provider_2, usr_provider_3, _inserted_date, _inserted_user, _last_modified_date, _last_modified_user) VALUES ('f58afb74-ff36-11eb-99e5-0242ac110002', true, 'BO-Plastiline SA', NULL, NULL, NULL, '2021-08-17 08:41:47.777336', NULL, '2021-08-17 08:41:47.777336', NULL);


--
-- Data for Name: sign; Type: TABLE DATA; Schema: signalo_od; Owner: postgres
--



--
-- Data for Name: support; Type: TABLE DATA; Schema: signalo_od; Owner: postgres
--



--
-- Data for Name: coating; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.coating (id, active, value_en, value_fr, value_de, description_en, description_fr, description_de) VALUES (1, true, 'unknown', 'inconnu', 'unknown', NULL, NULL, NULL);
INSERT INTO signalo_vl.coating (id, active, value_en, value_fr, value_de, description_en, description_fr, description_de) VALUES (2, true, 'other', 'autre', 'other', NULL, NULL, NULL);
INSERT INTO signalo_vl.coating (id, active, value_en, value_fr, value_de, description_en, description_fr, description_de) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined', NULL, NULL, NULL);
INSERT INTO signalo_vl.coating (id, active, value_en, value_fr, value_de, description_en, description_fr, description_de) VALUES (11, true, 'type 1 engineer grade (eg)', 'type 1 engineer grade (eg)', 'type 1 engineer grade (eg)', ' sign guarantees 10 years', 'signal garanti 10 ans', 'sign guarantees 10 years');
INSERT INTO signalo_vl.coating (id, active, value_en, value_fr, value_de, description_en, description_fr, description_de) VALUES (12, true, 'type 2 high intensity prismatic (hip) ', 'type 2 high intensity prismatic (hip) ', 'type 2 high intensity prismatic (hip) ', 'sign guarantees 13 years', 'signal garanti 13 ans', 'sign guarantees 13 years');
INSERT INTO signalo_vl.coating (id, active, value_en, value_fr, value_de, description_en, description_fr, description_de) VALUES (13, true, 'type 3 diamond grade (dg3) ', 'type 3 diamond grade (dg3) ', 'type 3 diamond grade (dg3) ', 'sign guarantees 15 years', 'signal garanti 15 ans', 'sign guarantees 15 years');
INSERT INTO signalo_vl.coating (id, active, value_en, value_fr, value_de, description_en, description_fr, description_de) VALUES (14, true, 'type i interior lighted panels', 'type i panneaux éclairés intérieurement', 'type i interior lighted panels', 'interior lighted panels', 'panneaux éclairés intérieurement', 'interior lighted panels');


--
-- Data for Name: durability; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.durability (id, active, value_en, value_fr, value_de) VALUES (1, true, 'unknown', 'inconnu', 'unknown');
INSERT INTO signalo_vl.durability (id, active, value_en, value_fr, value_de) VALUES (2, false, 'other', 'autre', 'other');
INSERT INTO signalo_vl.durability (id, active, value_en, value_fr, value_de) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined');
INSERT INTO signalo_vl.durability (id, active, value_en, value_fr, value_de) VALUES (10, true, 'permanent', 'permanent', 'permanent');
INSERT INTO signalo_vl.durability (id, active, value_en, value_fr, value_de) VALUES (11, true, 'temporary', 'temporaire', 'temporary');
INSERT INTO signalo_vl.durability (id, active, value_en, value_fr, value_de) VALUES (12, true, 'winter', 'hivernal', 'winter');


--
-- Data for Name: frame_fixing_type; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.frame_fixing_type (id, active, value_en, value_fr, value_de) VALUES (1, true, 'unknown', 'inconnu', 'unknown');
INSERT INTO signalo_vl.frame_fixing_type (id, active, value_en, value_fr, value_de) VALUES (2, true, 'other', 'autre', 'other');
INSERT INTO signalo_vl.frame_fixing_type (id, active, value_en, value_fr, value_de) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined');
INSERT INTO signalo_vl.frame_fixing_type (id, active, value_en, value_fr, value_de) VALUES (10, true, 'for frame with slides', 'pour cadre avec glissières', 'for frame with slides');
INSERT INTO signalo_vl.frame_fixing_type (id, active, value_en, value_fr, value_de) VALUES (11, true, 'for frame with fixation lateral', 'pour cadre avec fixation latérale', 'for frame with fixation lateral');
INSERT INTO signalo_vl.frame_fixing_type (id, active, value_en, value_fr, value_de) VALUES (12, true, 'for fixing the frame with Tespa tape', 'pour fixation du cadre avec bande Tespa', 'for fixing the frame with Tespa tape');
INSERT INTO signalo_vl.frame_fixing_type (id, active, value_en, value_fr, value_de) VALUES (13, true, 'rectangular for mounting on IPE', 'rectangulaire pour fixation sur IPE', 'rectangular for mounting on IPE');


--
-- Data for Name: frame_type; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.frame_type (id, active, value_en, value_fr, value_de) VALUES (1, true, 'unknown', 'inconnu', 'unknown');
INSERT INTO signalo_vl.frame_type (id, active, value_en, value_fr, value_de) VALUES (2, true, 'other', 'autre', 'other');
INSERT INTO signalo_vl.frame_type (id, active, value_en, value_fr, value_de) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined');
INSERT INTO signalo_vl.frame_type (id, active, value_en, value_fr, value_de) VALUES (10, true, 'direct assembly', 'montage direct', 'direct assembly');
INSERT INTO signalo_vl.frame_type (id, active, value_en, value_fr, value_de) VALUES (11, true, 'weld', 'soudé', 'weld');
INSERT INTO signalo_vl.frame_type (id, active, value_en, value_fr, value_de) VALUES (12, true, 'fit', 'emboîté', 'fit');
INSERT INTO signalo_vl.frame_type (id, active, value_en, value_fr, value_de) VALUES (13, true, 'with runner', 'avec glissières', 'with runner');
INSERT INTO signalo_vl.frame_type (id, active, value_en, value_fr, value_de) VALUES (14, true, 'Side mounting', 'A fixation latérale', 'Side mounting');


--
-- Data for Name: lighting; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.lighting (id, active, value_en, value_fr, value_de) VALUES (1, true, 'unknown', 'inconnu', 'unknown');
INSERT INTO signalo_vl.lighting (id, active, value_en, value_fr, value_de) VALUES (2, true, 'other', 'autre', 'other');
INSERT INTO signalo_vl.lighting (id, active, value_en, value_fr, value_de) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined');
INSERT INTO signalo_vl.lighting (id, active, value_en, value_fr, value_de) VALUES (10, true, 'none', 'aucun', 'none');
INSERT INTO signalo_vl.lighting (id, active, value_en, value_fr, value_de) VALUES (11, true, 'bulb', 'ampoule', 'bulb');
INSERT INTO signalo_vl.lighting (id, active, value_en, value_fr, value_de) VALUES (12, true, 'LED', 'LED', 'LED');
INSERT INTO signalo_vl.lighting (id, active, value_en, value_fr, value_de) VALUES (13, true, 'neon', 'néon', 'neon');


--
-- Data for Name: marker_type; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (1, true, 'TBD', 'inconnu', 'TBD', 'TBD');
INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (2, true, 'TBD', 'autre', 'TBD', 'TBD');
INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined', 'TBD');
INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (11, true, 'Leitpfosten', 'balise', 'TBD', 'TBD');
INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (12, true, 'Leitfeile', 'flèche de guidage', 'TBD', 'TBD');
INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (13, true, 'Leitmarken', 'bande de marquage', 'TBD', 'TBD');
INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (14, true, 'Leitbaken', 'balise de guidage', 'TBD', 'TBD');
INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (15, true, 'Inselpfosten', 'borne d''îlots', 'TBD', 'TBD');
INSERT INTO signalo_vl.marker_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (16, true, 'Verkhersteiler', 'séparateur de trafic', 'TBD', 'TBD');


--
-- Data for Name: mirror_shape; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.mirror_shape (id, active, value_de, value_fr, value_it, value_ro) VALUES (2, true, 'TBD', 'autre', 'TBD', 'TBD');
INSERT INTO signalo_vl.mirror_shape (id, active, value_de, value_fr, value_it, value_ro) VALUES (11, true, 'TBD', 'rectangulaire', 'TBD', 'TBD');
INSERT INTO signalo_vl.mirror_shape (id, active, value_de, value_fr, value_it, value_ro) VALUES (12, true, 'TBD', 'circulaire', 'TBD', 'TBD');


--
-- Data for Name: official_sign; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('0.1-d', true, 'touristisch', 'touristique', 'turistico', 'turistico', NULL, NULL, NULL, NULL, '01-d-touristic.svg', '01-d-touristic.svg', '01-d-touristic.svg', '01-d-touristic.svg', 100, 113, 0, 'Grand Tour', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('0.1-g', true, 'touristisch', 'touristique', 'turistico', 'turistico', NULL, NULL, NULL, NULL, '01-g-touristic.svg', '01-g-touristic.svg', '01-g-touristic.svg', '01-g-touristic.svg', 100, 113, 0, 'Grand Tour', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('0.2-d', true, 'Fussgänger', 'pédestre', 'pedona', 'pedona', NULL, NULL, NULL, NULL, '02-d-pedestrian.svg', '02-d-pedestrian.svg', '02-d-pedestrian.svg', '02-d-pedestrian.svg', 100, 113, 0, 'Tourisme pédestre', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('0.2-g', true, 'Fussgänger', 'pédestre', 'pedona', 'pedona', NULL, NULL, NULL, NULL, '02-g-pedestrian.svg', '02-g-pedestrian.svg', '02-g-pedestrian.svg', '02-g-pedestrian.svg', 100, 113, 0, 'Tourisme pédestre', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('0.3-d', true, 'Hotel', 'Hôtel', 'hotel', 'hotel', NULL, NULL, NULL, NULL, '03-d-hotel.svg', '03-d-hotel.svg', '03-d-hotel.svg', '03-d-hotel.svg', 100, 113, 0, 'Hotel Krone', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('0.3-g', true, 'Hotel', 'Hôtel', 'hotel', 'hotel', NULL, NULL, NULL, NULL, '03-g-hotel.svg', '03-g-hotel.svg', '03-g-hotel.svg', '03-g-hotel.svg', 100, 113, 0, 'Hotel Krone', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.01', true, 'Rechtskurve', 'Virage à droite', 'Curva a destra', NULL, NULL, NULL, NULL, NULL, '101.svg', '101.svg', '101.svg', '101.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.02', true, 'Linkskurve', 'Virage à gauche', 'Curva a sinistra', NULL, NULL, NULL, NULL, NULL, '102.svg', '102.svg', '102.svg', '102.svg', 100, 115, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.03', true, 'Doppelkurve nach rechts beginnend', 'Double virage, le premier à droite', 'Doppia curva, la prima a destra', NULL, NULL, NULL, NULL, NULL, '103.svg', '103.svg', '103.svg', '103.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.04', true, 'Doppelkurve nach links beginnend', 'Double virage, le premier à gauche', 'Doppia curva, la prima a sinistra', NULL, NULL, NULL, NULL, NULL, '104.svg', '104.svg', '104.svg', '104.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.05', true, 'Schleudergefahr', 'Chaussée glissante', 'Strada sdrucciolevole', NULL, NULL, NULL, NULL, NULL, '105.svg', '105.svg', '105.svg', '105.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.06', true, 'Unebene Fahrbahn', 'Cassis', 'Cunetta', NULL, NULL, NULL, NULL, NULL, '106.svg', '106.svg', '106.svg', '106.svg', 100, 112, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.07', true, 'Engpass', 'Chaussée rétrécie', 'Strada stretta', NULL, NULL, NULL, NULL, NULL, '107.svg', '107.svg', '107.svg', '107.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.08', true, 'Verengung rechts', 'Chaussée rétrécie à droite', 'Restringimento a destra', NULL, NULL, NULL, NULL, NULL, '108.svg', '108.svg', '108.svg', '108.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.09', true, 'Verengung links', 'Chaussée rétrécie à gauche', 'Restringimento a sinistra', NULL, NULL, NULL, NULL, NULL, '109.svg', '109.svg', '109.svg', '109.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.10', true, 'Gefährliches Gefälle', 'Descente dangereuse', 'Discesa pericolosa', NULL, NULL, NULL, NULL, NULL, '110.svg', '110.svg', '110.svg', '110.svg', 100, 113, 0, '10 %', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.11', true, 'Starke Steigung', 'Forte montée', 'Salita ripida', NULL, NULL, NULL, NULL, NULL, '111.svg', '111.svg', '111.svg', '111.svg', 100, 113, 0, '10 %', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.12', true, 'Rollsplitt', 'Gravillon', 'Ghiaia', NULL, NULL, NULL, NULL, NULL, '112.svg', '112.svg', '112.svg', '112.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.13', true, 'Steinschlag', 'Chute de pierres', 'Caduta di sassi', NULL, NULL, NULL, NULL, NULL, '113.svg', '113.svg', '113.svg', '113.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.14', true, 'Baustelle', 'Travaux', 'Lavori', NULL, NULL, NULL, NULL, NULL, '114.svg', '114.svg', '114.svg', '114.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.15', true, 'Schranken', 'Barrières', 'Barriere', NULL, NULL, NULL, NULL, NULL, '115.svg', '115.svg', '115.svg', '115.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.16', true, 'Bahnübergang ohne Schranken', '[[Passage à niveau]] sans barrières', 'Passaggio a livello senza barriere', NULL, NULL, NULL, NULL, NULL, '116.svg', '116.svg', '116.svg', '116.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.17', true, 'Distanzbaken', 'Panneaux indicateurs de distance', 'Tavole indicatrici di distanza', NULL, NULL, NULL, NULL, NULL, '117.svg', '117.svg', '117.svg', '117.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.18', true, 'Strassenbahn', 'Tramway ou chemin de fer routier', 'Tram', NULL, NULL, NULL, NULL, NULL, '118.svg', '118.svg', '118.svg', '118.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.22', true, 'Fussgängerstreifen', 'Passage pour piétons', 'Pedoni', NULL, NULL, NULL, NULL, NULL, '122.svg', '122.svg', '122.svg', '122.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.23', true, 'Kinder', 'Enfants', 'Bambini', NULL, NULL, NULL, NULL, NULL, '123.svg', '123.svg', '123.svg', '123.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.24', true, 'Wildwechsel', 'Passage de [[gibier]]', 'Passaggio di selvaggina', NULL, NULL, NULL, NULL, NULL, '124.svg', '124.svg', '124.svg', '124.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.25', true, 'Tiere', '[[Animal|Animaux]]', 'Animali', NULL, NULL, NULL, NULL, NULL, '125.svg', '125.svg', '125.svg', '125.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.25a', true, 'Tiere', '[[Animal|Animaux]] (variante)', 'Animali', NULL, NULL, NULL, NULL, NULL, '125a.svg', '125a.svg', '125a.svg', '125a.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.26', true, 'Gegenverkehr', 'Circulation en sens inverse', 'Traffico in senso inverso', NULL, NULL, NULL, NULL, NULL, '126.svg', '126.svg', '126.svg', '126.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.27', true, 'Lichtsignale', 'Signaux lumineux', 'Segnali luminosi', NULL, NULL, NULL, NULL, NULL, '127.svg', '127.svg', '127.svg', '127.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.28', true, 'Flugzeuge', 'Avions', 'Velivoli', NULL, NULL, NULL, NULL, NULL, '128.svg', '128.svg', '128.svg', '128.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.29', true, 'Seitenwind', '[[Vent]] latéral', 'Vento laterale', NULL, NULL, NULL, NULL, NULL, '129.svg', '129.svg', '129.svg', '129.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.30', true, 'Andere Gefahren', 'Autres [[Danger|dangers]]', 'Altri pericoli', NULL, NULL, NULL, NULL, NULL, '130.svg', '130.svg', '130.svg', '130.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.31', true, 'Stau', '[[Embouteillage_(route)|Bouchon]]', 'Colonna', NULL, NULL, NULL, NULL, NULL, '131.svg', '131.svg', '131.svg', '131.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('1.32', true, 'Radfahrer', 'Cyclistes', 'Ciclisti', NULL, NULL, NULL, NULL, NULL, '132.svg', '132.svg', '132.svg', '132.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.01', true, 'Allgemeines Fahrverbot in beiden Richtungen', 'Interdiction générale de circuler dans les deux sens', 'Divieto generale di circolazione nelle due direzioni', NULL, NULL, NULL, NULL, NULL, '201.svg', '201.svg', '201.svg', '201.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.02', true, 'Einfahrt verboten', 'Accès interdit', 'Divieto di accesso', NULL, NULL, NULL, NULL, NULL, '202.svg', '202.svg', '202.svg', '202.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.03', true, 'Verbot für Motorwagen', 'Circulation interdite aux voitures automobiles', 'Divieto di circo- lazione per gli autoveicoli', NULL, NULL, NULL, NULL, NULL, '203.svg', '203.svg', '203.svg', '203.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.04', true, 'Verbot für Motorräder', 'Circulation interdite aux motocycles', 'Divieto di circolazione per i motoveicoli', NULL, NULL, NULL, NULL, NULL, '204.svg', '204.svg', '204.svg', '204.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.05', true, 'Verbot für Fahrräder und Motorfahrräder', 'Circulation interdite aux cycles et cyclomoteurs', 'Divieto di circolazione per i velocipedi e i ciclo motori', NULL, NULL, NULL, NULL, NULL, '205.svg', '205.svg', '205.svg', '205.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.06', true, 'Verbot für Motorfahrräder', 'Circulation interdite aux cyclomoteurs', 'Divieto di circo- lazione per i ciclo motori', NULL, NULL, NULL, NULL, NULL, '206.svg', '206.svg', '206.svg', '206.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.07', true, 'Verbot für Lastwagen', 'Circulation interdite aux camions', 'Divieto di circolazione per gli autocarri', NULL, NULL, NULL, NULL, NULL, '207.svg', '207.svg', '207.svg', '207.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.08', true, 'Verbot für Gesellschaftswagen', 'Circulation interdite aux autocars', 'Divieto di circolazione per gli autobus', NULL, NULL, NULL, NULL, NULL, '208.svg', '208.svg', '208.svg', '208.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.09', true, 'Verbot für Anhänger', 'Circulation interdite aux remorques', 'Divieto di circo- lazione per i rimorchi', NULL, NULL, NULL, NULL, NULL, '209.svg', '209.svg', '209.svg', '209.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.09.1', true, 'Verbot für Anhänger mit Ausnahme von Sattel- und Einachsanhänger', 'Circulation interdite aux remorques autres que les semi-remorques et les remorques à essieu central', 'Divieto di circolazione per i rimorchi eccettuati i semirimorchi e i rimorchi a un asse', NULL, NULL, NULL, NULL, NULL, '209-1.svg', '209-1.svg', '209-1.svg', '209-1.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.10.1', true, 'Verbot für Fahrzeuge mit gefährlicher Ladung', 'Circulation interdite aux véhicules transportant des marchandises dangereuses', 'Divieto di circo- lazione per i veicoli che trasportano merci pricolose', NULL, NULL, NULL, NULL, NULL, '210-1.svg', '210-1.svg', '210-1.svg', '210-1.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.11', true, 'Verbot für Fahrzeuge mit wassergefährdender Ladung', 'Circulation interdite aux véhicules dont le chargement peut altérer les eaux', 'Divieto di circolazione per i veicoli il cui carico può inquinare le acque', NULL, NULL, NULL, NULL, NULL, '211.svg', '211.svg', '211.svg', '211.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.12', true, 'Verbot für Tiere', 'Circulation interdite aux animaux', 'Divieto di circolazione per gli animali', NULL, NULL, NULL, NULL, NULL, '212.svg', '212.svg', '212.svg', '212.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.13', true, 'Verbot für Motorwagen und Motorräder (Beispiel)', 'Circulation interdite aux voitures automobiles et aux motocycles', 'Divieto di circo- lazione per gli autoveicoli e i motoveicoli (esempio)', NULL, NULL, NULL, NULL, NULL, '213.svg', '213.svg', '213.svg', '213.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.14', true, 'Verbot für Motorwagen, Motorräder und Motor- fahrräder (Beispiel)', 'Circulation interdite aux voitures automobiles, aux motocycles et cyclomoteurs', 'Divieto di circolazione per gli autoveicoli i motoveicoli e i ciclomotori (esempio)', NULL, NULL, NULL, NULL, NULL, '214.svg', '214.svg', '214.svg', '214.svg', 100, 98, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.15', true, 'Verbot für Fussgänger', 'Accès interdit aux piétons', 'Accesso vietato ai pedoni', NULL, NULL, NULL, NULL, NULL, '215.svg', '215.svg', '215.svg', '215.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.15.1', true, 'Skifahren verboten', 'Interdiction de skier', 'Divieto di sciare', NULL, NULL, NULL, NULL, NULL, '215-1.svg', '215-1.svg', '215-1.svg', '215-1.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.15.2', true, 'Schlitteln verboten', 'Interdiction de luger', 'Divieto di slittare', NULL, NULL, NULL, NULL, NULL, '215-2.svg', '215-2.svg', '215-2.svg', '215-2.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.15.3', true, 'Verbot für fahrzeug- ähnliche Geräte', 'Circulation interdite aux engins assimilés à des véhicules', 'Divieto di circolazione per mezzi simili a veicoli', NULL, NULL, NULL, NULL, NULL, '215-3.svg', '215-3.svg', '215-3.svg', '215-3.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.16', true, 'Höchstgewicht', 'Poids maximal', 'Peso massimo', NULL, NULL, NULL, NULL, NULL, '216.svg', '216.svg', '216.svg', '216.svg', 100, 100, 0, '5,5', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.17', true, 'Achsdruck', 'Charge par essieu', 'Pressione sull’asse', NULL, NULL, NULL, NULL, NULL, '217.svg', '217.svg', '217.svg', '217.svg', 100, 100, 0, '2,4 t', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.18', true, 'Höchstbreite', 'Largeur maximale', 'Larghezza massima', NULL, NULL, NULL, NULL, NULL, '218.svg', '218.svg', '218.svg', '218.svg', 100, 100, 0, '2m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.19', true, 'Höchsthöhe', 'Hauteur maximale', 'Altezza massima', NULL, NULL, NULL, NULL, NULL, '219.svg', '219.svg', '219.svg', '219.svg', 100, 100, 0, '3,5m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.20', true, 'Höchstlänge', 'Longueur maximale', 'Lunghezza massima', NULL, NULL, NULL, NULL, NULL, '220.svg', '220.svg', '220.svg', '220.svg', 100, 100, 0, '10 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.30', true, 'Höchstgeschwindigkeit', 'Vitesse maximale', 'Velocità massima', NULL, NULL, NULL, NULL, NULL, '230.svg', '230.svg', '230.svg', '230.svg', 100, 100, 0, '60', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.30.1', true, 'Höchstgeschwindigkeit 50 generell', 'Vitesse maximale 50, Limite générale', 'Velocità massima 50, Limite generale', NULL, NULL, NULL, NULL, NULL, '230-1-a.svg', '230-1-b.svg', '230-1-c.svg', '230-1-d.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.31', true, 'Mindest- geschwindigkeit', 'Vitesse minimale', 'Velocità minima', NULL, NULL, NULL, NULL, NULL, '231.svg', '231.svg', '231.svg', '231.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.32', true, 'Fahrtrichtung rechts', 'Sens obligatoire à droite', 'Direzione obbligatoria a destra', NULL, NULL, NULL, NULL, NULL, '232.svg', '232.svg', '232.svg', '232.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.33', true, 'Fahrtrichtung links', 'Sens obligatoire à gauche', 'Direzione obbligatoria a sinistra', NULL, NULL, NULL, NULL, NULL, '233.svg', '233.svg', '233.svg', '233.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.34', true, 'Hindernis rechts umfahren', 'Obstacle à contourner par la droite', 'Ostacolo da scansare a destra', NULL, NULL, NULL, NULL, NULL, '234.svg', '234.svg', '234.svg', '234.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.35', true, 'Hindernis links umfahren', 'Obstacle à contourner par la gauche', 'Ostacolo da scansare a sinistra', NULL, NULL, NULL, NULL, NULL, '235.svg', '235.svg', '235.svg', '235.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.36', true, 'Geradeausfahren', 'Circuler tout droit', 'Circolare diritto', NULL, NULL, NULL, NULL, NULL, '236.svg', '236.svg', '236.svg', '236.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.37', true, 'Rechtsabbiegen', 'Obliquer à droite', 'Svoltare a destra', NULL, NULL, NULL, NULL, NULL, '237.svg', '237.svg', '237.svg', '237.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.38', true, 'Linksabbiegen', 'Obliquer à gauche', 'Svoltare a sinistra', NULL, NULL, NULL, NULL, NULL, '238.svg', '238.svg', '238.svg', '238.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.39', true, 'Rechts- oder Linksabbiegen', 'Obliquer à droite ou à gauche', 'Svoltare a destra o a sinistra', NULL, NULL, NULL, NULL, NULL, '239.svg', '239.svg', '239.svg', '239.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.40', true, 'Geradeaus oder Rechtsabbiegen', 'Circuler tout droit ou obliquer à droite', 'Circolare diritto o svoltare a destra', NULL, NULL, NULL, NULL, NULL, '240.svg', '240.svg', '240.svg', '240.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.41', true, 'Geradeaus oder Linksabbiegen', 'Circuler tout droit ou obliquer à gauche', 'Circolare diritto o svoltare a sinistra', NULL, NULL, NULL, NULL, NULL, '241.svg', '241.svg', '241.svg', '241.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.41.1', true, 'Kreisverkehrsplatz', 'Carrefour à sens giratoire', 'Area con percorso rotatorio obbligato', NULL, NULL, NULL, NULL, NULL, '241-1.svg', '241-1.svg', '241-1.svg', '241-1.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.41.2', true, 'Geradeaus oder Linksabbiegen', 'Sens obligatoire pour les véhicules transportant des marchandises dangereuses', 'Circolare diritto o svoltare a sinistra', NULL, NULL, NULL, NULL, NULL, '241-2.svg', '241-2.svg', '241-2.svg', '241-2.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.42', true, 'Abbiegen nach rechts verboten', 'Interdiction d''obliquer à droite', 'Divieto di svoltare a destra', NULL, NULL, NULL, NULL, NULL, '242.svg', '242.svg', '242.svg', '242.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.43', true, 'Abbiegen nach links verboten', 'Interdiction d''obliquer à gauche', 'Divieto di svoltare a sinistra', NULL, NULL, NULL, NULL, NULL, '243.svg', '243.svg', '243.svg', '243.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.44', true, 'Überholen verboten', 'Interdiction de dépasser', 'Divieto di sorpasso', NULL, NULL, NULL, NULL, NULL, '244.svg', '244.svg', '244.svg', '244.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.45', true, 'Überholen für Lastwagen verboten', 'Interdiction aux camions de dépasser', 'Divieto di sorpasso per gli autocarri', NULL, NULL, NULL, NULL, NULL, '245.svg', '245.svg', '245.svg', '245.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.46', true, 'Wenden verboten', 'Interdiction de faire demi-tour', 'Divieto d’inversione', NULL, NULL, NULL, NULL, NULL, '246.svg', '246.svg', '246.svg', '246.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.47', true, 'Mindestabstand', 'Distance minimale', 'Intervallo minimo', NULL, NULL, NULL, NULL, NULL, '247.svg', '247.svg', '247.svg', '247.svg', 100, 101, 0, '50 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.48', true, 'Schneeketten obligatorisch', 'Chaînes à neige obligatoires', 'Catene per la neve obbligatorie', NULL, NULL, NULL, NULL, NULL, '248.svg', '248.svg', '248.svg', '248.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.49', true, 'Halten verboten', 'Interdiction de s''arrêter', 'Divieto di fermata', NULL, NULL, NULL, NULL, NULL, '249.svg', '249.svg', '249.svg', '249.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.50', true, 'Parkieren verboten', 'Interdiction de parquer', 'Divieto di parcheggio', NULL, NULL, NULL, NULL, NULL, '250.svg', '250.svg', '250.svg', '250.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.51', true, 'Zollhaltestelle', 'Arrêt à proximité d''un poste de douane', 'Fermata al posto di dogana', NULL, NULL, NULL, NULL, NULL, '251-a.svg', '251-a.svg', '251-b.svg', '251-b.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.52', true, 'Polizei', 'Police', 'Polizia', NULL, NULL, NULL, NULL, NULL, '252-a.svg', '252-a.svg', '252-b.svg', '252-b.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.53', true, 'Ende der Höchstgeschwindigkeit', 'Fin de la vitesse maximale', 'Fine della velocità massima', NULL, NULL, NULL, NULL, NULL, '253.svg', '253.svg', '253.svg', '253.svg', 100, 100, 0, '60', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.53.1', true, 'Ende der Höchstgeschwindigkeit 50 generell', 'Fin de la vitesse maximale générale', 'Fine della velocità massima 50, Limite generale', NULL, NULL, NULL, NULL, NULL, '253-1-a.svg', '253-1-b.svg', '253-1-c.svg', '253-1-d.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.54', true, 'Ende der Mindestgeschwindigkeit', 'Fin de la vitesse minimale', 'Fine della velocità minima', NULL, NULL, NULL, NULL, NULL, '254.svg', '254.svg', '254.svg', '254.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.55', true, 'Ende des Überholverbotes (Beispiel)', 'Fin de l''interdiction de dépasser', 'Fine del divieto di sorpasso', NULL, NULL, NULL, NULL, NULL, '255.svg', '255.svg', '255.svg', '255.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.56', true, 'Ende des Überholverbotes für Lastwagen', 'Fin de l''interdiction aux camions de dépasser', 'Fine del divieto di sorpasso per gli autocarri', NULL, NULL, NULL, NULL, NULL, '256.svg', '256.svg', '256.svg', '256.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.56.1', true, 'Ende eines Teilfahrverbotes (Fahrstreifen)', 'Fin de l''interdiction partielle de circuler', 'Fine del divieto parziale di circolazione (esempio)', NULL, NULL, NULL, NULL, NULL, '256-1.svg', '256-1.svg', '256-1.svg', '256-1.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.49-g', true, 'Betriebswegweiser', 'Indicateur de direction «Entreprise»', 'Indicatore di direzione per aziende', NULL, NULL, NULL, NULL, NULL, '449-g.svg', '449-g.svg', '449-g.svg', '449-g.svg', 60, 308, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.57', true, 'Ende des Schneeketten- Obligatoriums', 'Fin de l''obligation d’utiliser des chaînes à neige', 'Fine dell’obbligo di utilizzare le catene per la neve', NULL, NULL, NULL, NULL, NULL, '257.svg', '257.svg', '257.svg', '257.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.58', true, 'Freie Fahrt', 'Libre circulation', 'Via Libera', NULL, NULL, NULL, NULL, NULL, '258.svg', '258.svg', '258.svg', '258.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.1-30', true, 'Zonensignal (z. B. Tempo-30-Zone)', 'Signal de zone 30', 'Segnale per zone (ad es. limite di velocità massima di 30 km/h)', NULL, NULL, NULL, NULL, NULL, '259-1-a.svg', '259-1-a.svg', '259-1-d.svg', '259-1-d.svg', 125, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.1-NP', true, 'Zonensignal (z. B. Tempo-30-Zone)', 'Signal de zone sans stationnement', 'Segnale per zone (ad es. limite di velocità massima di 30 km/h)', NULL, NULL, NULL, NULL, NULL, '259-1-b.svg', '259-1-b.svg', '259-1-e.svg', '259-1-e.svg', 125, 91, 0, '07.00 - 19.00 h', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.1-P', true, 'Zonensignal (z. B. Tempo-30-Zone)', 'Signal de zone de parc', 'Segnale per zone (ad es. limite di velocità massima di 30 km/h)', NULL, NULL, NULL, NULL, NULL, '259-1-c.svg', '259-1-c.svg', '259-1-f.svg', '259-1-f.svg', 125, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.2-30', true, 'Ende-Zonensignal (z. B. Ende Tempo- 30-Zone)', 'Signal de zone 30', 'Fine del segnale per zone (ad es. limite di velocità massimo di 30 km/h)', NULL, NULL, NULL, NULL, NULL, '259-2-a.svg', '259-2-a.svg', '259-2-d.svg', '259-2-d.svg', 125, 90, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.2-NP', true, 'Ende-Zonensignal (z. B. Ende Tempo- 30-Zone)', 'Signal de zone sans stationnement', 'Fine del segnale per zone (ad es. limite di velocità massimo di 30 km/h)', NULL, NULL, NULL, NULL, NULL, '259-2-b.svg', '259-2-b.svg', '259-2-e.svg', '259-2-e.svg', 125, 91, 0, '07.00 - 19.00 h', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.2-P', true, 'Ende-Zonensignal (z. B. Ende Tempo- 30-Zone)', 'Signal de zone de parc', 'Fine del segnale per zone (ad es. limite di velocità massimo di 30 km/h)', NULL, NULL, NULL, NULL, NULL, '259-2-c.svg', '259-2-c.svg', '259-2-f.svg', '259-2-f.svg', 125, 90, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.3', true, 'Fussgängerzone', 'Zone piétonne', 'Zona pedonale', NULL, NULL, NULL, NULL, NULL, '259-3-a.svg', '259-3-a.svg', '259-3-b.svg', '259-3-b.svg', 125, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.4', true, 'Ende der Fussgänger- zone', 'Fin de la zone piétonne', 'Fine della zone pedonale', NULL, NULL, NULL, NULL, NULL, '259-4-a.svg', '259-4-a.svg', '259-4-b.svg', '259-4-b.svg', 125, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.5', true, 'Begegnungszone', 'Zone de rencontre', 'Zone d’incontro', NULL, NULL, NULL, NULL, NULL, '259-5-a.svg', '259-5-a.svg', '259-5-b.svg', '259-5-b.svg', 80, 112, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.59.6', true, 'Ende der Begegnungszone', 'Fin de la zone de rencontre', 'Fine della zona d’incontro', NULL, NULL, NULL, NULL, NULL, '259-6-a.svg', '259-6-a.svg', '259-6-b.svg', '259-6-b.svg', 80, 112, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.60', true, 'Radweg', 'Piste cyclable', 'Ciclopista', NULL, NULL, NULL, NULL, NULL, '260.svg', '260.svg', '260.svg', '260.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.60.1', true, 'Ende des Radweges', 'Fin de la piste cyclable', 'Fine della ciclopista', NULL, NULL, NULL, NULL, NULL, '260-1.svg', '260-1.svg', '260-1.svg', '260-1.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.61', true, 'Fussweg', 'Chemin pour piétons', 'Strada pedonale', NULL, NULL, NULL, NULL, NULL, '261.svg', '261.svg', '261.svg', '261.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.62', true, 'Reitweg', 'Allée d''équitation', 'Strada per cavalli da sella', NULL, NULL, NULL, NULL, NULL, '262.svg', '262.svg', '262.svg', '262.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.63', true, 'Rad- und Fussweg mit getrennten Verkehrsflächen (Beispiel)', 'Piste cyclable et chemin pour piétons, avec partage de l''aire de circulation', 'Ciclopista e strada pedonale divise per categoria (esempio)', NULL, NULL, NULL, NULL, NULL, '263.svg', '263.svg', '263.svg', '263.svg', 100, 99, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.63.1', true, 'Gemeinsamer Rad- und Fussweg (Beispiel)', 'Piste cyclable et chemin pour piétons sans partage de l''aire de circulation', 'Ciclopista e strada pedonale (esempio)', NULL, NULL, NULL, NULL, NULL, '263-1.svg', '263-1.svg', '263-1.svg', '263-1.svg', 100, 99, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.64', true, 'Busfahrbahn', 'Chaussée réservée aux bus', 'Carreggiata riservata ai bus', NULL, NULL, NULL, NULL, NULL, '264.svg', '264.svg', '264.svg', '264.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('2.65', true, 'Lichtsignal-System für die zeitweilige Sperrung von Fahrstreifen', 'Système de signaux lumineux pour la fermeture temporaire des voies de circulation', 'Sistema di segnali luminosi per la chiusura temporanea delle corsie', NULL, NULL, NULL, NULL, NULL, '265.svg', '265.svg', '265.svg', '265.svg', 80, 277, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.01', true, 'Stop', 'Stop', 'Stop', NULL, NULL, NULL, NULL, NULL, '301.svg', '301.svg', '301.svg', '301.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.02', true, 'Kein Vortritt', 'Cédez le passage', 'Dare precedenza', NULL, NULL, NULL, NULL, NULL, '302.svg', '302.svg', '302.svg', '302.svg', 100, 112, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.03', true, 'Hauptstrasse', 'Route principale', 'Strada principale', NULL, NULL, NULL, NULL, NULL, '303.svg', '303.svg', '303.svg', '303.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.04', true, 'Ende der Hauptstrasse', 'Fin de la route principale', 'Fine della strada principale', NULL, NULL, NULL, NULL, NULL, '304.svg', '304.svg', '304.svg', '304.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.05', true, 'Verzweigung mit Strasse ohne Vortritt', 'Intersection avec une route sans priorité', 'Intersezione con strada senza precedenza', NULL, NULL, NULL, NULL, NULL, '305.svg', '305.svg', '305.svg', '305.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.06', true, 'Verzweigung mit Rechtsvortritt', 'Intersection comportant la priorité de droite', 'Intersezione con precedenza da destra', NULL, NULL, NULL, NULL, NULL, '306.svg', '306.svg', '306.svg', '306.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.07', true, 'Einfahrt von rechts', 'Entrée par la droite', 'Entrata da destra', NULL, NULL, NULL, NULL, NULL, '307.svg', '307.svg', '307.svg', '307.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.08', true, 'Einfahrt von links', 'Entrée par la gauche', 'Entrata da sinistra', NULL, NULL, NULL, NULL, NULL, '308.svg', '308.svg', '308.svg', '308.svg', 100, 113, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.09', true, 'Dem Gegenverkehr Vortritt lassen', 'Laissez passer les véhicules en sens inverse', 'Lasciar passare i veicoli provenienti in senso inverso', NULL, NULL, NULL, NULL, NULL, '309.svg', '309.svg', '309.svg', '309.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.10', true, 'Vortritt vor dem Gegenverkehr', 'Priorité par rapport aux véhicules venant en sens inverse', 'Precedenza rispetto al traffico inverso', NULL, NULL, NULL, NULL, NULL, '310.svg', '310.svg', '310.svg', '310.svg', 100, 101, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.20', true, 'Wechselblinklicht', 'Signal à feux clignotant alternativement', 'Luci lampeggianti alternativamente', NULL, NULL, NULL, NULL, NULL, '320.svg', '320.svg', '320.svg', '320.svg', 100, 112, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.21', true, 'Einfaches Blinklicht', 'Signal à feu clignotant simple', 'Luce lampeggiante semplice', NULL, NULL, NULL, NULL, NULL, '321.svg', '321.svg', '321.svg', '321.svg', 100, 108, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.22', true, 'Einfaches Andreaskreuz', 'Croix de St-André simple', 'Croce di Sant’Andrea semplice', NULL, NULL, NULL, NULL, NULL, '322.svg', '322.svg', '322.svg', '322.svg', 100, 181, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.23', true, 'Doppeltes Andreaskreuz', 'Croix de St-André double', 'Croce di Sant’Andrea doppia', NULL, NULL, NULL, NULL, NULL, '323.svg', '323.svg', '323.svg', '323.svg', 100, 128, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.24', true, 'Einfaches Andreaskreuz', 'Croix de St-André simple', 'Croce di Sant’Andrea semplice', NULL, NULL, NULL, NULL, NULL, '324.svg', '324.svg', '324.svg', '324.svg', 100, 52, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('3.25', true, 'Doppeltes Andreaskreuz', 'Croix de St-André double', 'Croce di Sant’Andrea doppia', NULL, NULL, NULL, NULL, NULL, '325.svg', '325.svg', '325.svg', '325.svg', 100, 36, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.01', true, 'Autobahn', 'Autoroute', 'Autostrada', NULL, NULL, NULL, NULL, NULL, '401.svg', '401.svg', '401.svg', '401.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.02', true, 'Ende der Autobahn', 'Fin de l''autoroute', 'Fine dell’autostrada', NULL, NULL, NULL, NULL, NULL, '402.svg', '402.svg', '402.svg', '402.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.03', true, 'Autostrasse', 'Semi-autoroute', 'Semiautostrada', NULL, NULL, NULL, NULL, NULL, '403.svg', '403.svg', '403.svg', '403.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.04', true, 'Ende der Autostrasse', 'Fin de la semi-autoroute', 'Fine della semi- autostrada', NULL, NULL, NULL, NULL, NULL, '404.svg', '404.svg', '404.svg', '404.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.05', true, 'Bergpoststrasse', 'Route postale de montagne', 'Strada postale di montagna', NULL, NULL, NULL, NULL, NULL, '405.svg', '405.svg', '405.svg', '405.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.06', true, 'Ende der Bergpoststrasse', 'Fin de la route postale de montagne', 'Fine della strada po stale di montagne', NULL, NULL, NULL, NULL, NULL, '406.svg', '406.svg', '406.svg', '406.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.07', true, 'Tunnel', 'Tunnel', 'Galleria', NULL, NULL, NULL, NULL, NULL, '407.svg', '407.svg', '407.svg', '407.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.08', true, 'Einbahnstrasse', 'Sens unique', 'Senso unico', NULL, NULL, NULL, NULL, NULL, '408.svg', '408.svg', '408.svg', '408.svg', 100, 101, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.08.1', true, 'Einbahnstrasse mit Gegenverkehr von Radfahrern (Beispiel)', 'Sens unique avec circulation de cyclistes en sens inverse', 'Senso unico con circolazione di ciclisti in senso in verso (esempio)', NULL, NULL, NULL, NULL, NULL, '408-1.svg', '408-1.svg', '408-1.svg', '408-1.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.09', true, 'Sackgasse', '[[Impasse]]', 'Strada senza uscita', NULL, NULL, NULL, NULL, NULL, '409.svg', '409.svg', '409.svg', '409.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.10', true, 'Wasserschutz- gebiet', 'Zone de protection des eaux', 'Zona di protezione delle acque', NULL, NULL, NULL, NULL, NULL, '410.svg', '410.svg', '410.svg', '410.svg', 100, 72, 0, '2km', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.11', true, 'Standort eines Fussgängerstreifens', 'Emplacement d''un [[passage pour piétons]]', 'Ubicazione di un passaggio pedonale', NULL, NULL, NULL, NULL, NULL, '411.svg', '411.svg', '411.svg', '411.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.12', true, 'Fussgänger- Unterführung', 'Passage souterrain pour piétons', 'Sottopassaggio pedonale', NULL, NULL, NULL, NULL, NULL, '412.svg', '412.svg', '412.svg', '412.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.13', true, 'Fussgänger- Überführung', 'Passerelle pour piétons', 'Cavalcavia pedonale', NULL, NULL, NULL, NULL, NULL, '413.svg', '413.svg', '413.svg', '413.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.14', true, 'Spital', 'Hôpital', 'Ospedale', NULL, NULL, NULL, NULL, NULL, '414.svg', '414.svg', '414.svg', '414.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.15', true, 'Ausstellplatz', 'Place d''évitement', 'Piazzuola', NULL, NULL, NULL, NULL, NULL, '415.svg', '415.svg', '415.svg', '415.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.16', true, 'Abstellplatz für Pannenfahrzeuge', 'Place d''arrêt pour véhicules en panne', 'Posto di fermata per veicoli in panna', NULL, NULL, NULL, NULL, NULL, '416.svg', '416.svg', '416.svg', '416.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.17', true, 'Parkieren gestattet', 'Parcage autorisé', 'Parcheggio', NULL, NULL, NULL, NULL, NULL, '417.svg', '417.svg', '417.svg', '417.svg', 100, 101, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.18', true, 'Parkieren mit Parkscheibe', 'Parcage avec disque de stationnement', 'Parcheggio con disco', NULL, NULL, NULL, NULL, NULL, '418.svg', '418.svg', '418.svg', '418.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.19', true, 'Ende des Parkierens mit Parkscheibe', 'Fin du parcage avec disque de stationnement', 'Fine del parcheggio con disco', NULL, NULL, NULL, NULL, NULL, '419.svg', '419.svg', '419.svg', '419.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.20', true, 'Parkieren gegen Gebühr', 'Parcage contre paiement', 'Parcheggio contro pagamento', NULL, NULL, NULL, NULL, NULL, '420.svg', '420.svg', '420.svg', '420.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.21', true, 'Parkhaus', 'Parking couvert', 'Parcheggio coperto', NULL, NULL, NULL, NULL, NULL, '421.svg', '421.svg', '421.svg', '421.svg', 100, 101, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.22', true, 'Entfernung und Richtung eines Parkplatzes', 'Distance et direction d''un parking', 'Distanza e direzione di un parcheggio', NULL, NULL, NULL, NULL, NULL, '422.svg', '422.svg', '422.svg', '422.svg', 100, 72, 0, '50 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.23', true, 'Vorwegweiser für bestimmte Fahrzeug- arten (Beispiel Lastwagen)', 'Indicateur de direction avancé pour des genres de véhicules déterminés', 'Segnale avanzato per determinare categorie di veicoli (ad es. autocarri)', NULL, NULL, NULL, NULL, NULL, '423.svg', '423.svg', '423.svg', '423.svg', 100, 72, 0, '50 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.24', true, 'Notfallspur (Beispiel)', 'Voie de détresse', 'Uscita di scampo (esempio)', NULL, NULL, NULL, NULL, NULL, '424.svg', '424.svg', '424.svg', '424.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.25', true, 'Parkplatz mit Anschluss an öffentliches Verkehrsmittel (Beispiel)', 'Parking avec accès aux transports publics', 'Parcheggio con collegamento a un mezzo di trasporto pubblico (esempio)', NULL, NULL, NULL, NULL, NULL, '425.svg', '425.svg', '425.svg', '425.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.27', true, 'Ortsbeginn auf Hauptstrassen', 'Début de localité sur route principale (Suisse)', 'Inizio della località sulle strade principali', NULL, NULL, NULL, NULL, NULL, '427.svg', '427.svg', '427.svg', '427.svg', 80, 110, 0, 'Biel', 'Bienne', 'BE', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.28', true, 'Ortsende auf Hauptstrassen', 'Fin de localité sur route principale (Suisse)', 'Fine della località sulle strade principali', NULL, NULL, NULL, NULL, NULL, '428.svg', '428.svg', '428.svg', '428.svg', 80, 110, 0, 'Lyss', 'Bern', '21 km', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.29', true, 'Ortsbeginn auf Nebenstrassen', 'Début de localité sur route secondaire (Suisse)', 'Inizio della località sulle strade secondarie', NULL, NULL, NULL, NULL, NULL, '429.svg', '429.svg', '429.svg', '429.svg', 80, 109, 0, 'Maur', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.30', true, 'Ortsende auf Nebenstrassen', 'Fin de localité sur route secondaire (Suisse)', 'Fine della località sulle strade secondarie', NULL, NULL, NULL, NULL, NULL, '430.svg', '430.svg', '430.svg', '430.svg', 80, 110, 0, 'Mönchaltorf', 'Rüti', '14 km', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.31-1-d', true, 'Wegweiser zu Autobahnen oder Autostrassen (1 ligne, flèche à droite)', 'Indicateur de direction pour autoroutes et semi-autoroutes (1 ligne, flèche à droite)', 'Indicatore di direzione per le autostrade e semiautostrade (1 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '431-1-d.svg', '431-1-d.svg', '431-1-d.svg', '431-1-d.svg', 60, 236, 0, 'Basel', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.31-1-g', true, 'Wegweiser zu Autobahnen oder Autostrassen (1 ligne, flèche à gauche)', 'Indicateur de direction pour autoroutes et semi-autoroutes (1 ligne, flèche à gauche)', 'Indicatore di direzione per le autostrade e semiautostrade (1 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '431-1-g.svg', '431-1-g.svg', '431-1-g.svg', '431-1-g.svg', 60, 236, 0, 'Basel', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.31-2-d', true, 'Wegweiser zu Autobahnen oder Autostrassen (2 ligne, flèche à droite)', 'Indicateur de direction pour autoroutes et semi-autoroutes (2 ligne, flèche à droite)', 'Indicatore di direzione per le autostrade e semiautostrade (2 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '431-2-d.svg', '431-2-d.svg', '431-2-d.svg', '431-2-d.svg', 60, 236, 0, 'Basel', 'Zürich', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.31-2-g', true, 'Wegweiser zu Autobahnen oder Autostrassen (2 ligne, flèche à gauche)', 'Indicateur de direction pour autoroutes et semi-autoroutes (2 ligne, flèche à gauche)', 'Indicatore di direzione per le autostrade e semiautostrade (2 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '431-2-g.svg', '431-2-g.svg', '431-2-g.svg', '431-2-g.svg', 60, 236, 0, 'Basel', 'Zürich', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.31-3-d', true, 'Wegweiser zu Autobahnen oder Autostrassen (3 ligne, flèche à droite)', 'Indicateur de direction pour autoroutes et semi-autoroutes (3 ligne, flèche à droite)', 'Indicatore di direzione per le autostrade e semiautostrade (3 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '431-3-d.svg', '431-3-d.svg', '431-3-d.svg', '431-3-d.svg', 60, 236, 0, 'Basel', 'Zürich', 'Opfikon', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.31-3-g', true, 'Wegweiser zu Autobahnen oder Autostrassen (3 ligne, flèche à gauche)', 'Indicateur de direction pour autoroutes et semi-autoroutes (3 ligne, flèche à gauche)', 'Indicatore di direzione per le autostrade e semiautostrade (3 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '431-3-g.svg', '431-3-g.svg', '431-3-g.svg', '431-3-g.svg', 60, 236, 0, 'Basel', 'Zürich', 'Opfikon', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.32-1-d', true, 'Wegweiser für Hauptstrassen (1 ligne, flèche à droite)', 'Indicateur de direction pour routes principales (1 ligne, flèche à droite)', 'Indicatore di direzione per le strade principali (1 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '432-1-d.svg', '432-1-d.svg', '432-1-d.svg', '432-1-d.svg', 60, 236, 0, 'Zürich', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.32-1-g', true, 'Wegweiser für Hauptstrassen (1 ligne, flèche à gauche)', 'Indicateur de direction pour routes principales (1 ligne, flèche à gauche)', 'Indicatore di direzione per le strade principali (1 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '432-1-g.svg', '432-1-g.svg', '432-1-g.svg', '432-1-g.svg', 60, 236, 0, 'Zürich', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.32-2-d', true, 'Wegweiser für Hauptstrassen (2 ligne, flèche à droite)', 'Indicateur de direction pour routes principales (2 ligne, flèche à droite)', 'Indicatore di direzione per le strade principali (2 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '432-2-d.svg', '432-2-d.svg', '432-2-d.svg', '432-2-d.svg', 60, 236, 0, 'Zürich', 'Basel', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.32-2-g', true, 'Wegweiser für Hauptstrassen (2 ligne, flèche à gauche)', 'Indicateur de direction pour routes principales (2 ligne, flèche à gauche)', 'Indicatore di direzione per le strade principali (2 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '432-2-g.svg', '432-2-g.svg', '432-2-g.svg', '432-2-g.svg', 60, 236, 0, 'Zürich', 'Basel', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.32-3-d', true, 'Wegweiser für Hauptstrassen (3 ligne, flèche à droite)', 'Indicateur de direction pour routes principales (3 ligne, flèche à droite)', 'Indicatore di direzione per le strade principali (3 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '432-3-d.svg', '432-3-d.svg', '432-3-d.svg', '432-3-d.svg', 60, 236, 0, 'Zürich', 'Basel', 'Opfikon', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.32-3-g', true, 'Wegweiser für Hauptstrassen (3 ligne, flèche à gauche)', 'Indicateur de direction pour routes principales (3 ligne, flèche à gauche)', 'Indicatore di direzione per le strade principali (3 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '432-3-g.svg', '432-3-g.svg', '432-3-g.svg', '432-3-g.svg', 60, 236, 0, 'Zürich', 'Basel', 'Opfikon', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.33-1-d', true, 'Wegweiser für Nebenstrassen (1 ligne, flèche à droite)', 'Indicateur de direction pour routes secondaires (1 ligne, flèche à droite)', 'Indicatore di direzione per le strade secondarie (1 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '433-1-d.svg', '433-1-d.svg', '433-1-d.svg', '433-1-d.svg', 60, 241, 0, 'Flims', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.33-1-g', true, 'Wegweiser für Nebenstrassen (1 ligne, flèche à gauche)', 'Indicateur de direction pour routes secondaires (1 ligne, flèche à gauche)', 'Indicatore di direzione per le strade secondarie (1 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '433-1-g.svg', '433-1-g.svg', '433-1-g.svg', '433-1-g.svg', 60, 241, 0, 'Flims', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.33-2-d', true, 'Wegweiser für Nebenstrassen (2 ligne, flèche à droite)', 'Indicateur de direction pour routes secondaires (2 ligne, flèche à droite)', 'Indicatore di direzione per le strade secondarie (2 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '433-2-d.svg', '433-2-d.svg', '433-2-d.svg', '433-2-d.svg', 60, 241, 0, 'Flims', 'Laax', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.33-2-g', true, 'Wegweiser für Nebenstrassen (2 ligne, flèche à gauche)', 'Indicateur de direction pour routes secondaires (2 ligne, flèche à gauche)', 'Indicatore di direzione per le strade secondarie (2 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '433-2-g.svg', '433-2-g.svg', '433-2-g.svg', '433-2-g.svg', 60, 241, 0, 'Flims', 'Laax', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.33-3-d', true, 'Wegweiser für Nebenstrassen (3 ligne, flèche à droite)', 'Indicateur de direction pour routes secondaires (3 ligne, flèche à droite)', 'Indicatore di direzione per le strade secondarie (3 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '433-3-d.svg', '433-3-d.svg', '433-3-d.svg', '433-3-d.svg', 60, 241, 0, 'Flims', 'Laax', 'Trin', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.33-3-g', true, 'Wegweiser für Nebenstrassen (3 ligne, flèche à gauche)', 'Indicateur de direction pour routes secondaires (3 ligne, flèche à gauche)', 'Indicatore di direzione per le strade secondarie (3 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '433-3-g.svg', '433-3-g.svg', '433-3-g.svg', '433-3-g.svg', 60, 241, 0, 'Flims', 'Laax', 'Trin', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.34-d', true, 'Wegweiser bei Umleitungen (1 ligne, flèche à droite)', 'Indicateur de direction pour déviation (1 ligne, flèche à droite)', 'Indicatore di direzione per deviazione (1 ligne, flèche à droite)', NULL, NULL, NULL, NULL, NULL, '434-d.svg', '434-d.svg', '434-d.svg', '434-d.svg', 60, 241, 0, 'Lugano', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.34-g', true, 'Wegweiser bei Umleitungen (1 ligne, flèche à gauche)', 'Indicateur de direction pour déviation (1 ligne, flèche à gauche)', 'Indicatore di direzione per deviazione (1 ligne, flèche à gauche)', NULL, NULL, NULL, NULL, NULL, '434-g.svg', '434-g.svg', '434-g.svg', '434-g.svg', 60, 241, 0, 'Lugano', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.35', true, 'Wegweiser in Tabellenform', 'Indicateur de direction en forme de tableau', 'Indicatore di direzione a forma di tabella', NULL, NULL, NULL, NULL, NULL, '435.svg', '435.svg', '435.svg', '435.svg', 120, 167, 0, 'Zürich', 'Basel', 'Luzern', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.36', true, 'Vorwegweiser auf Hauptstrassen', 'Indicateur de direction avancé sur route principale', 'Indicatore di direzione avanzato su strada principale', NULL, NULL, NULL, NULL, NULL, '436.svg', '436.svg', '436.svg', '436.svg', 200, 236, 0, 'Basel', 'Zürich', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.37', true, 'Vorwegweiser auf Nebenstrassen', 'Indicateur de direction avancé sur route secondaire', 'Indicatore di direzione avanzato su strada seconda', NULL, NULL, NULL, NULL, NULL, '437.svg', '437.svg', '437.svg', '437.svg', 200, 314, 0, 'Beatenberg', 'Habkern', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.38', true, 'Vorwegweiser mit Fahrstreifenaufteilung auf Hauptstrassen', 'Indicateur de direction avancé avec répartition des voies sur route principale', 'Indicatore di direzione avanzato con ripartizione delle corsie su strada principale', NULL, NULL, NULL, NULL, NULL, '438.svg', '438.svg', '438.svg', '438.svg', 200, 169, 0, 'Genève', 'Lausanne', 'Yverdon', 'Prilly');
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.39', true, 'Vorwegweiser mit Fahrstreifenaufteilung auf Nebenstrassen', 'Indicateur de direction avancé avec répartition des voies sur route secondaire', 'Indicatore di direzione avanzato con ripartizione delle corsie su strada secondarie', NULL, NULL, NULL, NULL, NULL, '439.svg', '439.svg', '439.svg', '439.svg', 200, 251, 0, 'Zimmerwald', 'Bern', 'Kehrsatz', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.40', true, 'Vorwegweiser mit Anzeige von Beschränkungen', 'Indicateur de direction avancé annonçant des restrictions', 'Indicatore di direzione avanzato annunciante una limitazione', NULL, NULL, NULL, NULL, NULL, '440.svg', '440.svg', '440.svg', '440.svg', 200, 255, 0, 'Arosa', 'Julier', '2,3m', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.41', true, 'Einspurtafel über Fahrstreifen auf Hauptstrassen', 'Panneau de présélection au-dessus d''une voie de circulation sur route principale', 'Cartello di preselezione collocato al di sopra di una corsia su strada principale', NULL, NULL, NULL, NULL, NULL, '441.svg', '441.svg', '441.svg', '441.svg', 200, 218, 0, 'Bern', 'Lausanne', 'Aigle', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.42', true, 'Einspurtafel über Fahrstreifen auf Nebenstrassen', 'Panneau de présélection au-dessus d''une voie de circulation sur route secondaire', 'Cartello di preselezione collocato al di sopra di una corsia su strada secondaria', NULL, NULL, NULL, NULL, NULL, '442.svg', '442.svg', '442.svg', '442.svg', 200, 208, 0, 'Bern', 'Kehrsatz', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.45-d', true, 'Wegweiser für bestimmte Fahrzeugarten (Beispiel Lastwagen)', ' Indicateur de direction pour des genres de véhicules déterminés', 'Indicatore di direzione per determinare categorie di veicoli (ad es. autocarri)', NULL, NULL, NULL, NULL, NULL, '445-d.svg', '445-d.svg', '445-d.svg', '445-d.svg', 60, 241, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.45-g', true, 'Wegweiser für bestimmte Fahrzeugarten (Beispiel Lastwagen)', ' Indicateur de direction pour des genres de véhicules déterminés', 'Indicatore di direzione per determinare categorie di veicoli (ad es. autocarri)', NULL, NULL, NULL, NULL, NULL, '445-g.svg', '445-g.svg', '445-g.svg', '445-g.svg', 60, 241, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.46-d', true, 'Wegweiser ''Parkplatz''', 'Indicateur de direction «Place de stationnement»', 'Indicatore di direzione ''Parcheggio''', NULL, NULL, NULL, NULL, NULL, '446-d.svg', '446-d.svg', '446-d.svg', '446-d.svg', 60, 241, 0, '300 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.46-g', true, 'Wegweiser ''Parkplatz''', 'Indicateur de direction «Place de stationnement»', 'Indicatore di direzione ''Parcheggio''', NULL, NULL, NULL, NULL, NULL, '446-g.svg', '446-g.svg', '446-g.svg', '446-g.svg', 60, 241, 0, '300 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.46.1-d', true, 'Wegweiser ''Parkplatz mit Anschluss an öffentliches Verkehrsmittel'' (Beispiel)', 'Indicateur de direction «Parking avec accès aux transports publics»', 'Indicatore di direzione ''Parcheggio con collegamento a un mezzo di trasporto pubblico'' (esempio)', NULL, NULL, NULL, NULL, NULL, '446-1-d.svg', '446-1-d.svg', '446-1-d.svg', '446-1-d.svg', 60, 241, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.46.1-g', true, 'Wegweiser ''Parkplatz mit Anschluss an öffentliches Verkehrsmittel'' (Beispiel)', 'Indicateur de direction «Parking avec accès aux transports publics»', 'Indicatore di direzione ''Parcheggio con collegamento a un mezzo di trasporto pubblico'' (esempio)', NULL, NULL, NULL, NULL, NULL, '446-1-g.svg', '446-1-g.svg', '446-1-g.svg', '446-1-g.svg', 60, 241, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.47-d', true, 'Wegweiser ''Zeltplatz''', 'Indicateur de direction «Place de camping»', 'Indicatore di direzione ''Campeggio''', NULL, NULL, NULL, NULL, NULL, '447-d.svg', '447-d.svg', '447-d.svg', '447-d.svg', 60, 241, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.47-g', true, 'Wegweiser ''Zeltplatz''', 'Indicateur de direction «Place de camping»', 'Indicatore di direzione ''Campeggio''', NULL, NULL, NULL, NULL, NULL, '447-g.svg', '447-g.svg', '447-g.svg', '447-g.svg', 60, 241, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.48-d', true, 'Wegweiser ''Wohnwagenplatz''', 'Indicateur de direction «Terrain pour caravanes»', 'Indicatore di direzione ''Terreno per veicoli abitabili''', NULL, NULL, NULL, NULL, NULL, '448-d.svg', '448-d.svg', '448-d.svg', '448-d.svg', 60, 241, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.48-g', true, 'Wegweiser ''Wohnwagenplatz''', 'Indicateur de direction «Terrain pour caravanes»', 'Indicatore di direzione ''Terreno per veicoli abitabili''', NULL, NULL, NULL, NULL, NULL, '448-g.svg', '448-g.svg', '448-g.svg', '448-g.svg', 60, 241, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.49-d', true, 'Betriebswegweiser', 'Indicateur de direction «Entreprise»', 'Indicatore di direzione per aziende', NULL, NULL, NULL, NULL, NULL, '449-d.svg', '449-d.svg', '449-d.svg', '449-d.svg', 60, 308, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.50.1-d', true, 'Wegweiser «Route für Fahrräder» (Beispiel)', 'Indicateur de direction «Itinéraire pour cyclistes» (exemple)', 'Indicatore di direzione «Percorso raccomandato per velocipedi» (Esempio)', NULL, NULL, NULL, NULL, NULL, '450-1-d.svg', '450-1-d.svg', '450-1-d.svg', '450-1-d.svg', 60, 301, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.50.1-g', true, 'Wegweiser «Route für Fahrräder» (Beispiel)', 'Indicateur de direction «Itinéraire pour cyclistes» (exemple)', 'Indicatore di direzione «Percorso raccomandato per velocipedi» (Esempio)', NULL, NULL, NULL, NULL, NULL, '450-1-g.svg', '450-1-g.svg', '450-1-g.svg', '450-1-g.svg', 60, 301, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.50.3', true, 'Wegweiser «Route für Mountainbikes» (Beispiel)', 'Indicateur de direction «Itinéraire pour vélos tout terrain» (exemple)', 'Indicatore di direzione «Percorso per mountain-bike» (Esempio)', NULL, NULL, NULL, NULL, NULL, '450-3.svg', '450-3.svg', '450-3.svg', '450-3.svg', 60, 301, 0, 'Martigny', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.50.4', true, 'Wegweiser «Route für fahrzeugähnliche Geräte» (Beispiel)', 'Indicateur de direction «Itinéraire pour engins assimilés à des véhicules» (exemple)', 'Indicatore di direzione «Percorso per mezzi simili a veicoli» (Esempio)', NULL, NULL, NULL, NULL, NULL, '450-4.svg', '450-4.svg', '450-4.svg', '450-4.svg', 60, 231, 0, 'Alpsee', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.50.5', true, 'Wegweiser in Tabellenform für einen einzigen Adressatenkreis (Beispiel)', 'Indicateur de direction en forme de tableau destiné à un seul cercle d''usagers (exemple)', 'Indicatore di direzione a forma di tabella per una sola cerchia di utilizzatori (Esempio)', NULL, NULL, NULL, NULL, NULL, '450-5.svg', '450-5.svg', '450-5.svg', '450-5.svg', 120, 115, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.50.6', true, 'Wegweiser in Tabellenform für mehrere Adressatenkreise (Beispiel)', 'Indicateur de direction en forme de tableau destiné à plusieurs cercles d''usagers (exemple)', 'Indicatore di direzione a forma di tabella per più cherchie di utilizzatori (Esempio)', NULL, NULL, NULL, NULL, NULL, '450-6.svg', '450-6.svg', '450-6.svg', '450-6.svg', 120, 179, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.51.1-d', true, 'Wegweiser ohne Zielangabe (Beispiel)', 'Indicateur de direction sans destination (exemple)', 'Indicatore di direzione senza destinazione (Esempio)', NULL, NULL, NULL, NULL, NULL, '451-1-d.svg', '451-1-d.svg', '451-1-d.svg', '451-1-d.svg', 60, 201, 0, 'Lausanne', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.51.1-g', true, 'Wegweiser ohne Zielangabe (Beispiel)', 'Indicateur de direction sans destination (exemple)', 'Indicatore di direzione senza destinazione (Esempio)', NULL, NULL, NULL, NULL, NULL, '451-1-g.svg', '451-1-g.svg', '451-1-g.svg', '451-1-g.svg', 60, 201, 0, 'Lausanne', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.51.2', true, 'Vorwegweiser ohne Zielangabe (Beispiel)', 'Indicateur de direction avancé sans destination (exemple)', 'Indicatore di direzione avanzato senza destinazione (Esempio)', NULL, NULL, NULL, NULL, NULL, '451-2.svg', '451-2.svg', '451-2.svg', '451-2.svg', 100, 65, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.51.3', true, 'Bestätigungstafel (Beispiel)', 'Plaque de confirmation (exemple)', 'Cartello di conferma (Esempio)', NULL, NULL, NULL, NULL, NULL, '451-3.svg', '451-3.svg', '451-3.svg', '451-3.svg', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.51.4', true, 'Endetafel (Beispiel)', 'Plaque indiquant la fin d''un itinéraire (exemple)', 'Cartello di fine percorso (Esempio)', NULL, NULL, NULL, NULL, NULL, '451-4.svg', '451-4.svg', '451-4.svg', '451-4.svg', 100, 94, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.52', true, 'Verkehrsführung', 'Guidage du trafic', 'Guida del traffico', NULL, NULL, NULL, NULL, NULL, '452.svg', '452.svg', '452.svg', '452.svg', 80, 112, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.53', true, 'Vorwegweiser für Umleitungen', 'Indicateur de direction avancé annonçant une déviation', 'Indicatore di direzione avanzato annunciante una deviazione', NULL, NULL, NULL, NULL, NULL, '453.svg', '453.svg', '453.svg', '453.svg', 200, 228, 0, 'Luzern', 'Buchrain', 'Inwil', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.54', true, 'Vorwegweiser bei Kreisverkehrsplatz (Beispiel)', 'Indicateur de direction avancé pour carrefour à sens giratoire', 'Indicatore di direzione avanzato presso aree con percorso rotatorio obbligato (esempio)', NULL, NULL, NULL, NULL, NULL, '454.svg', '454.svg', '454.svg', '454.svg', 200, 226, 0, 'Murten', 'Bern', 'Biel', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.55', true, 'Abzweigende Strasse mit Gefahrenstelle oder Verkehrsbeschränkung', 'Route latérale comportant un danger ou une restriction', 'Strada laterale che implica un pericolo o una restrizione', NULL, NULL, NULL, NULL, NULL, '455.svg', '455.svg', '455.svg', '455.svg', 200, 257, 0, '50 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.56', true, 'Nummerntafeln für Europastrassen', 'Plaque numérotée pour routes européennes', 'Tavoletta numerata per le strade europee', NULL, NULL, NULL, NULL, NULL, '456.svg', '456.svg', '456.svg', '456.svg', 80, 139, 0, 'E35', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.57', true, 'Nummerntafel für Hauptstrassen', 'Plaque numérotée pour routes principales', 'Tavoletta nume- rata per le strade principali', NULL, NULL, NULL, NULL, NULL, '457.svg', '457.svg', '457.svg', '457.svg', 80, 94, 0, '21', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.58', true, 'Nummerntafel für Autobahnen und Autostrassen', 'Plaque numérotée pour autoroutes et semi- autoroutes', 'Tavoletta numerata per autostrade e semi- autostrade', NULL, NULL, NULL, NULL, NULL, '458.svg', '458.svg', '458.svg', '458.svg', 80, 139, 0, '2', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.59', true, 'Nummerntafel für Anschlüsse', 'Plaque numérotée pour jonctions', 'Tavoletta numerata per raccordi', NULL, NULL, NULL, NULL, NULL, '459.svg', '459.svg', '459.svg', '459.svg', 80, 157, 0, '43', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.59.1', true, 'Nummerntafel für Verzweigungen', 'Plaque numérotée pour ramifications', 'Tavoletta numerata per ramificazioni', NULL, NULL, NULL, NULL, NULL, '459-1.svg', '459-1.svg', '459-1.svg', '459-1.svg', 80, 157, 0, '38', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.60', true, 'Ankündigung des nächsten Anschlusses', 'Panneau annonçant la prochaine jonction', 'Cartello preannunciante il prossimo raccordo', NULL, NULL, NULL, NULL, NULL, '460.svg', '460.svg', '460.svg', '460.svg', 200, 412, 0, 'Niederbipp', '1000 m', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.61', true, 'Vorwegweiser bei Anschlüssen', 'Indicateur de direction avancé, destiné aux jonctions', 'Indicatore di direzione avanzato ai raccordi', NULL, NULL, NULL, NULL, NULL, '461.svg', '461.svg', '461.svg', '461.svg', 200, 279, 0, 'Oensingen', 'Niederbipp', 'Langenthal', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.62', true, 'Wegweiser bei Anschlüssen', 'Indicateur de direction avancé destiné aux jonctions', 'Indicatore di direzione ai raccordi', NULL, NULL, NULL, NULL, NULL, '462.svg', '462.svg', '462.svg', '462.svg', 200, 268, 0, 'Niederbipp', 'Langenthal', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.63', true, 'Ausfahrtstafel', 'Panneau indicateur de sortie', 'Indicatore d’uscita', NULL, NULL, NULL, NULL, NULL, '463-a.svg', '463-b.svg', '463-c.svg', '463-c.svg', 200, 201, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.64', true, 'Trennungstafel', 'Panneau de bifurcation', 'Cartello di biforcazione', NULL, NULL, NULL, NULL, NULL, '464.svg', '464.svg', '464.svg', '464.svg', 200, 442, 0, 'Thun', 'Gunten', 'Heimberg', 'Seftigen');
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.65', true, 'Entfernungstafel', 'Panneau des distances en kilomètres', 'Cartello delle distanze in chilometri', NULL, NULL, NULL, NULL, NULL, '465.svg', '465.svg', '465.svg', '465.svg', 200, 362, 0, 'Zürich', 'Basel', 'Lausanne', 'Bern');
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.66', true, 'Verzweigungstafel', 'Panneau de ramification', 'Cartello di ramificazione', NULL, NULL, NULL, NULL, NULL, '466.svg', '466.svg', '466.svg', '466.svg', 200, 184, 0, '1500 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.67', true, 'Erster Vorwegweiser bei Verzweigungen', 'Premier indicateur de direction avancé, destiné aux ramifications', 'Primo indicatore di direzione avanzato alle ramificazioni', NULL, NULL, NULL, NULL, NULL, '467.svg', '467.svg', '467.svg', '467.svg', 200, 307, 0, 'Lausanne', 'Bern', '1000 m', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.68', true, 'Zweiter Vorwegweiser bei Verzweigungen', 'Deuxième indicateur de direction avancé, destiné aux ramifications', 'Secondo indicatore di direzione avanzato alle ramificazioni', NULL, NULL, NULL, NULL, NULL, '468.svg', '468.svg', '468.svg', '468.svg', 200, 226, 0, 'Luzern', 'Interlaken', 'Spiez', NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.69', true, 'Einspurtafel über Fahrstreifen auf Autobahnen und Autostrassen', 'Panneau de présélection au- dessus d''une voie de circulation sur autoroute et semi-autoroute', 'Cartello di preselezione collocato al di sopra di una corsia su autostrada o semi- autostrada', NULL, NULL, NULL, NULL, NULL, '469.svg', '469.svg', '469.svg', '469.svg', 200, 215, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.70', true, 'Hinweis auf Notruf säulen', 'Plaque indiquant un téléphone de secours', 'Tavola indicante un telefono di soccorso', NULL, NULL, NULL, NULL, NULL, '470.svg', '470.svg', '470.svg', '470.svg', 100, 87, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.71', true, 'Hinweis auf Polizeistützpunkte', 'Panneau indiquant un centre de police', 'Cartello indicante un centro di polizia', NULL, NULL, NULL, NULL, NULL, '471-a.svg', '471-b.svg', '471-c.svg', '471-c.svg', 100, 156, 0, '800', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.72', true, 'Kilometertafel', 'Plaque indiquant le nombre de kilomètres', 'Cartello indicante i chilometri', NULL, NULL, NULL, NULL, NULL, '472.svg', '472.svg', '472.svg', '472.svg', 100, 98, 0, '220', '2', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.73', true, 'Hektometertafel', 'Plaque indiquant le nombre d''hectomètre', 's Cartello indicante gli ettometri', NULL, NULL, NULL, NULL, NULL, '473.svg', '473.svg', '473.svg', '473.svg', 80, 129, 0, '24.5', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.75', true, 'Strassenzustand', 'Etat de la route', 'Stato delle strade', NULL, NULL, NULL, NULL, NULL, '475.svg', '475.svg', '475.svg', '475.svg', 200, 140, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.76', true, 'Vororientierung über den Strassenzustand', 'Préavis sur l''état de la route', 'Preavviso sullo stato delle strade', NULL, NULL, NULL, NULL, NULL, '476.svg', '476.svg', '476.svg', '476.svg', 200, 214, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.77', true, 'Anzeige der Fahrstreifen (Beispiele)', 'Disposition des voies de circulation', 'Disposizione delle corsie (esempi)', NULL, NULL, NULL, NULL, NULL, '477.svg', '477.svg', '477.svg', '477.svg', 100, 276, 0, '80', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.77.1', true, 'Anzeige von Fahrstreifen mit Beschränkungen (Beispiel)', 'Disposition des voies de circulation annonçant des restrictions', 'Disposizione delle corsie con restrizioni (esempio)', NULL, NULL, NULL, NULL, NULL, '477-1.svg', '477-1.svg', '477-1.svg', '477-1.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.79', true, 'Zeltplatz', '[[Place de camping]]', 'Campeggio', NULL, NULL, NULL, NULL, NULL, '479.svg', '479.svg', '479.svg', '479.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.80', true, 'Wohnwagenplatz', 'Terrain pour caravanes', 'Terreno per veicoli abitabili', NULL, NULL, NULL, NULL, NULL, '480.svg', '480.svg', '480.svg', '480.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.81', true, 'Telefon', 'Téléphone', 'Telefono', NULL, NULL, NULL, NULL, NULL, '481.svg', '481.svg', '481.svg', '481.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.82', true, 'Erste Hilfe', 'Premiers secours', 'Primo soccorso', NULL, NULL, NULL, NULL, NULL, '482.svg', '482.svg', '482.svg', '482.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.83', true, 'Pannenhilfe', '[[Poste de dépannage]]', 'Assistenza meccanica', NULL, NULL, NULL, NULL, NULL, '483.svg', '483.svg', '483.svg', '483.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.84', true, 'Tankstelle', '[[Poste d''essence]]', 'Rifornimento', NULL, NULL, NULL, NULL, NULL, '484.svg', '484.svg', '484.svg', '484.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.85', true, 'Hotel-Motel', 'Hôtel-Môtel', 'Albergo-motel', NULL, NULL, NULL, NULL, NULL, '485.svg', '485.svg', '485.svg', '485.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.86', true, 'Restaurant', 'Restaurant', 'Ristorante', NULL, NULL, NULL, NULL, NULL, '486.svg', '486.svg', '486.svg', '486.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.87', true, 'Erfrischungen', 'Rafraîchissement', 'Bar', NULL, NULL, NULL, NULL, NULL, '487.svg', '487.svg', '487.svg', '487.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.88', true, 'Informationsstelle', 'Poste d''information', 'Informazioni', NULL, NULL, NULL, NULL, NULL, '488.svg', '488.svg', '488.svg', '488.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.89', true, 'Jugendherberge', '[[Auberge de jeunesse]]', 'Ostello', NULL, NULL, NULL, NULL, NULL, '489.svg', '489.svg', '489.svg', '489.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.90', true, 'Radio-Verkehrs- information', 'Bulletin routier radiophonique', 'Bollettino radio sulle condizioni del traffico', NULL, NULL, NULL, NULL, NULL, '490.svg', '490.svg', '490.svg', '490.svg', 100, 71, 0, 'DRS', '94,6', NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.91', true, 'Gottesdienst', 'Service religieux', 'Funzioni religiose', NULL, NULL, NULL, NULL, NULL, '491-a.svg', '491-b.svg', '491-c.svg', '491-d.svg', 100, 67, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.92', true, 'Feuerlöscher', 'Extincteur', 'Estintore', NULL, NULL, NULL, NULL, NULL, '492.svg', '492.svg', '492.svg', '492.svg', 100, 72, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.93', true, 'Anzeige der allgemeinen Höchstgeschwindigkeiten', 'Information sur les limitations générales de vitesse', 'Informazioni sui limiti generali di velocità', NULL, NULL, NULL, NULL, NULL, '493.svg', '493.svg', '493.svg', '493.svg', 200, 101, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.94', true, 'Richtung und Entfernung zum Nächsten Notausgang', 'Direction et distance vers l''issue de secours la plus proche', 'Direzione della prossima uscita die sicurezza e distanza da essa', NULL, NULL, NULL, NULL, NULL, '494.svg', '494.svg', '494.svg', '494.svg', 80, 165, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('4.95', true, 'Notausgang', 'Issue de secours', 'Uscita di sicurezza', NULL, NULL, NULL, NULL, NULL, '495.svg', '495.svg', '495.svg', '495.svg', 100, 71, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.00', true, 'TBT', 'Plaque complémentaire', 'TBT', NULL, NULL, NULL, NULL, NULL, '500.svg', '500.svg', '500.svg', '500.svg', 60, 175, 0, '80', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.01', true, 'Distanztafel', 'Plaque de distance', 'Cartello di distanza', NULL, NULL, NULL, NULL, NULL, '501.svg', '501.svg', '501.svg', '501.svg', 60, 175, 0, '80', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.02', true, 'Anzeige von Entfernung und Richtung', 'Plaque indiquant la distance et la direction', 'Cartello indicante la distanza e la direzione', NULL, NULL, NULL, NULL, NULL, '502.svg', '502.svg', '502.svg', '502.svg', 80, 113, 0, '50 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.03', true, 'Streckenlänge', 'Longueur du tronçon', 'Lunghezza del tratto', NULL, NULL, NULL, NULL, NULL, '503.svg', '503.svg', '503.svg', '503.svg', 60, 175, 0, '2,5 km', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.04', true, 'Wiederholungstafel', 'Plaque de rappel', 'Cartello di ripetizione', NULL, NULL, NULL, NULL, NULL, '504.svg', '504.svg', '504.svg', '504.svg', 100, 34, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.05', true, 'Anfangstafel', 'Plaque indiquant le début d''une prescription', 'Cartello d’inizio', NULL, NULL, NULL, NULL, NULL, '505.svg', '505.svg', '505.svg', '505.svg', 100, 34, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.06', true, 'Endetafel', ' Plaque indiquant la fin d''une prescription', 'Cartello di fine', NULL, NULL, NULL, NULL, NULL, '506.svg', '506.svg', '506.svg', '506.svg', 100, 34, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.07', true, 'Richtungstafel', 'Plaque de direction', 'Cartello di direzione', NULL, NULL, NULL, NULL, NULL, '507.svg', '507.svg', '507.svg', '507.svg', 60, 147, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.09', true, 'Richtung der Hauptstrasse', 'Direction de la route principale', 'Direzione della strada principale', NULL, NULL, NULL, NULL, NULL, '509.svg', '509.svg', '509.svg', '509.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.10', true, 'Ausnahmen vom Halteverbot', 'Dérogation à l''interdiction de s''arrêter', 'Deroghe al divieto di fermata', NULL, NULL, NULL, NULL, NULL, '510.svg', '510.svg', '510.svg', '510.svg', 200, 298, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.11', true, 'Ausnahmen vom Parkierungsverbot', 'Dérogation à l''inter- diction de parquer', 'Deroghe al divieto di parcheggio', NULL, NULL, NULL, NULL, NULL, '511.svg', '511.svg', '511.svg', '511.svg', 60, 172, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.12', true, 'Blinklicht', 'Feux clignotants', 'Luce lampeggiante', NULL, NULL, NULL, NULL, NULL, '512.svg', '512.svg', '512.svg', '512.svg', 60, 175, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.13', true, 'Vereiste Fahrbahn', 'Chaussée verglacée', 'Carreggiata gelata', NULL, NULL, NULL, NULL, NULL, '513.svg', '513.svg', '513.svg', '513.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.14', true, 'Gehbehinderte', 'Handicapés', 'Invalidi', NULL, NULL, NULL, NULL, NULL, '514.svg', '514.svg', '514.svg', '514.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.15', true, 'Fahrbahnbreite', 'Largeur de la chaussée', 'Larghezza della carreggiata', NULL, NULL, NULL, NULL, NULL, '515.svg', '515.svg', '515.svg', '515.svg', 60, 175, 0, '3,20 m', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.16', true, 'Schiesslärm', 'Bruit de tirs', 'Rumore esercizi di tiro', NULL, NULL, NULL, NULL, NULL, '516.svg', '516.svg', '516.svg', '516.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.17', true, 'Übernächste Tankstelle', 'Poste d''essence suivant', 'Successivo posto di rifornimento', NULL, NULL, NULL, NULL, NULL, '517.svg', '517.svg', '517.svg', '517.svg', 60, 175, 0, '48 km', NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.20', true, 'Leichte Motorwagen', 'Voiture automobile légère', 'Autoveicoli leggeri', NULL, NULL, NULL, NULL, NULL, '520.svg', '520.svg', '520.svg', '520.svg', 50, 140, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.21', true, 'Schwere Motorwagen', 'Voitures automobiles lourdes', 'Autoveicoli pesanti', NULL, NULL, NULL, NULL, NULL, '521.svg', '521.svg', '521.svg', '521.svg', 50, 222, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.22', true, 'Lastwagen', 'Camion', 'Autocarro', NULL, NULL, NULL, NULL, NULL, '522.svg', '522.svg', '522.svg', '522.svg', 50, 97, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.23', true, 'Lastwagen mit Anhänger', 'Camion avec remorque', 'Autocarro con rimorchio', NULL, NULL, NULL, NULL, NULL, '523.svg', '523.svg', '523.svg', '523.svg', 50, 169, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.24', true, 'Sattelmotorfahrzeug', 'Véhicule articulé', 'Autoarticolato', NULL, NULL, NULL, NULL, NULL, '524.svg', '524.svg', '524.svg', '524.svg', 50, 130, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.25', true, 'Gesellschaftswagen', 'Autocar', 'Autobus', NULL, NULL, NULL, NULL, NULL, '525.svg', '525.svg', '525.svg', '525.svg', 50, 117, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.26', true, 'Anhänger', 'Remorque', 'Rimorchio', NULL, NULL, NULL, NULL, NULL, '526.svg', '526.svg', '526.svg', '526.svg', 50, 119, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.27', true, 'Wohnanhänger', 'Caravane', 'Rimorchio abitabile', NULL, NULL, NULL, NULL, NULL, '527.svg', '527.svg', '527.svg', '527.svg', 50, 76, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.28', true, 'Wohnmotorwagen', 'Voiture d''habitation', 'Autoveicolo abitabile', NULL, NULL, NULL, NULL, NULL, '528.svg', '528.svg', '528.svg', '528.svg', 50, 90, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.29', true, 'Motorrad', 'Motocycle', 'Motoveicolo', NULL, NULL, NULL, NULL, NULL, '529.svg', '529.svg', '529.svg', '529.svg', 50, 91, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.30', true, 'Motorfahrrad', 'Cyclomoteur', 'Ciclomotore', NULL, NULL, NULL, NULL, NULL, '530.svg', '530.svg', '530.svg', '530.svg', 50, 94, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.31', true, 'Fahrrad', 'Cycle', 'Velocipede', NULL, NULL, NULL, NULL, NULL, '531.svg', '531.svg', '531.svg', '531.svg', 50, 73, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.32', true, 'Mountain-Bike', 'Vélo tout-terrain', 'Mountain-Bike', NULL, NULL, NULL, NULL, NULL, '532.svg', '532.svg', '532.svg', '532.svg', 50, 45, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.33', true, 'Fahrrad schieben', 'Pousser le cycle', 'Spingere il velocipede', NULL, NULL, NULL, NULL, NULL, '533.svg', '533.svg', '533.svg', '533.svg', 50, 50, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.34', true, 'Fussgänger', 'Piéton', 'Pedone', NULL, NULL, NULL, NULL, NULL, '534.svg', '534.svg', '534.svg', '534.svg', 50, 25, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.35', true, 'Strassenbahn', 'Tramway ou chemin de fer routier', 'Tram', NULL, NULL, NULL, NULL, NULL, '535.svg', '535.svg', '535.svg', '535.svg', 50, 106, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.36', true, 'Traktor', 'Tracteur', 'Trattore', NULL, NULL, NULL, NULL, NULL, '536b.svg', '536b.svg', '536b.svg', '536b.svg', 50, 77, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.37', true, 'Panzer', 'Char', 'Carro armato', NULL, NULL, NULL, NULL, NULL, '537.svg', '537.svg', '537.svg', '537.svg', 50, 119, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.38', true, 'Pistenfahrzeug', 'Dameuse de pistes', 'Veicolo cingolato per la preparazione di piste', NULL, NULL, NULL, NULL, NULL, '538.svg', '538.svg', '538.svg', '538.svg', 50, 98, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.39', true, 'Langlauf', 'Ski de fond', 'Sci di fondo', NULL, NULL, NULL, NULL, NULL, '539.svg', '539.svg', '539.svg', '539.svg', 50, 70, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.40', true, 'Skifahren', 'Skier', 'Sciare', NULL, NULL, NULL, NULL, NULL, '540.svg', '540.svg', '540.svg', '540.svg', 50, 52, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.41', true, 'Schlitteln', 'Luge', 'Slittare', NULL, NULL, NULL, NULL, NULL, '541.svg', '541.svg', '541.svg', '541.svg', 50, 54, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.50', true, 'Flugzeug/Flugplatz', 'Avion/Aérodrome', 'Velivol/Aeroporto', NULL, NULL, NULL, NULL, NULL, '550.svg', '550.svg', '550.svg', '550.svg', 50, 60, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.51', true, 'Autoverlad auf Eisenbahn', 'Quai de chargement pour le transport sur rail', 'Carico di autoveicoli su ferrovia', NULL, NULL, NULL, NULL, NULL, '551.svg', '551.svg', '551.svg', '551.svg', 50, 156, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.52', true, 'Autoverlad auf Fähre', 'Quai de chargement pour le transport sur un bac', 'Carico di autoveicoli su traghetto', NULL, NULL, NULL, NULL, NULL, '552.svg', '552.svg', '552.svg', '552.svg', 50, 136, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.53', true, 'Industrie und Gewerbegebiet', 'Zone industrielle et artisanale', 'Zona industriale e artigianale', NULL, NULL, NULL, NULL, NULL, '553.svg', '553.svg', '553.svg', '553.svg', 50, 50, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.54', true, 'Zollabfertigung mit Sichtdeklaration', 'Passage en douane avec dédouanement à vue', 'Sdoganamento con dichiarazione a vista', NULL, NULL, NULL, NULL, NULL, '554.svg', '554.svg', '554.svg', '554.svg', 0, 0, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.56', true, 'Spital mit Notfallstation', 'Hôpital avec service d''urgence', 'Ospedale con pronto soccorso', NULL, NULL, NULL, NULL, NULL, '556.svg', '556.svg', '556.svg', '556.svg', 100, 100, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.57', true, 'Notfalltelefon', 'Téléphone de secours', 'Telefono d''emergenza', NULL, NULL, NULL, NULL, NULL, '557.svg', '557.svg', '557.svg', '557.svg', 100, 102, 0, NULL, NULL, NULL, NULL);
INSERT INTO signalo_vl.official_sign (id, active, value_de, value_fr, value_it, value_ro, description_de, description_fr, description_it, description_ro, img_de, img_fr, img_it, img_ro, img_height, img_width, no_dynamic_inscription, default_inscription1, default_inscription2, default_inscription3, default_inscription4) VALUES ('5.58', true, 'Feuerlöscher', 'Extincteur', 'Estintore', NULL, NULL, NULL, NULL, NULL, '558.svg', '558.svg', '558.svg', '558.svg', 100, 54, 0, NULL, NULL, NULL, NULL);


--
-- Data for Name: sign_type; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.sign_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (1, true, 'TBD', 'inconnu', 'TBD', 'TBD');
INSERT INTO signalo_vl.sign_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (2, true, 'TBD', 'autre', 'TBD', 'TBD');
INSERT INTO signalo_vl.sign_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined', 'TBD');
INSERT INTO signalo_vl.sign_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (11, true, 'TBD', 'officiel', 'TBD', 'TBD');
INSERT INTO signalo_vl.sign_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (12, true, 'TBD', 'balise', 'TBD', 'TBD');
INSERT INTO signalo_vl.sign_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (13, true, 'TBD', 'miroir', 'TBD', 'TBD');
INSERT INTO signalo_vl.sign_type (id, active, value_de, value_fr, value_it, value_ro) VALUES (14, true, 'TBD', 'plaque de rue', 'TBD', 'TBD');


--
-- Data for Name: status; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.status (id, active, value_en, value_fr, value_de) VALUES (1, true, 'unknown', 'inconnu', 'unknown');
INSERT INTO signalo_vl.status (id, active, value_en, value_fr, value_de) VALUES (2, false, 'other', 'autre', 'other');
INSERT INTO signalo_vl.status (id, active, value_en, value_fr, value_de) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined');
INSERT INTO signalo_vl.status (id, active, value_en, value_fr, value_de) VALUES (10, true, 'ok', 'en état', 'ok');
INSERT INTO signalo_vl.status (id, active, value_en, value_fr, value_de) VALUES (11, true, 'damaged', 'endommagé', 'damaged');
INSERT INTO signalo_vl.status (id, active, value_en, value_fr, value_de) VALUES (12, true, 'broken', 'détruit', 'broken');


--
-- Data for Name: support_base_type; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (1, true, 'unknown', 'inconnu', 'unknown');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (2, true, 'other', 'autre', 'other');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (11, true, 'tubular metal socket', 'douille métallique tubulaire', 'tubular metal socket');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (12, true, 'tubular metal socket with blades', 'douille métallique tubulaire à ailettes', 'tubular metal socket with blades');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (13, true, 'Drilled socket', 'douille forée', 'Drilled socket');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (14, true, 'mounting flange with socket', 'Flasque de fixation avec douille', 'mounting flange with socket');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (15, true, 'prefabricated concrete', 'préfabriquée en béton', 'prefabricated concrete');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (16, true, 'SPCH–Type 3', 'SPCH–Type 3', 'SPCH–Type 3');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (17, true, 'SPCH–Type 4', 'SPCH–Type 4', 'SPCH–Type 4');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (18, true, 'SPCH-Type 5', 'SPCH-Type 5', 'SPCH-Type 5');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (19, true, 'SPCH-Type 6', 'SPCH-Type 6', 'SPCH-Type 6');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (20, true, 'OFROU-Type A', 'OFROU-Type A', 'OFROU-Type A');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (21, true, 'OFROU-Type B', 'OFROU-Type B', 'OFROU-Type B');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (22, true, 'OFROU-Type C', 'OFROU-Type C', 'OFROU-Type C');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (23, true, 'OFROU-Type D', 'OFROU-Type D', 'OFROU-Type D');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (24, true, 'OFROU-Type E', 'OFROU-Type E', 'OFROU-Type E');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (25, true, 'OFROU-Type F', 'OFROU-Type F', 'OFROU-Type F');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (26, true, 'OFROU-Type 100', 'OFROU-Type 100', 'OFROU-Type 100');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (27, true, 'OFROU-Type 150', 'OFROU-Type 150', 'OFROU-Type 150');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (28, true, 'OFROU-Type 200', 'OFROU-Type 200', 'OFROU-Type 200');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (29, true, 'OFROU-Type 250', 'OFROU-Type 250', 'OFROU-Type 250');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (30, true, 'OFROU-Type 300', 'OFROU-Type 300', 'OFROU-Type 300');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (31, true, 'OFROU-Type 300 DS', 'OFROU-Type 300 DS', 'OFROU-Type 300 DS');
INSERT INTO signalo_vl.support_base_type (id, active, value_en, value_fr, value_de) VALUES (32, true, 'Slide post', 'Poteau de glissière', 'Slide post');


--
-- Data for Name: support_type; Type: TABLE DATA; Schema: signalo_vl; Owner: postgres
--

INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (1, true, 'unknown', 'inconnu', 'unknown');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (2, true, 'other', 'autre', 'other');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (3, true, 'to be determined', 'à déterminer', 'to be determined');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (10, true, 'tubular', 'tubulaire', 'tubular');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (11, true, 'triangulate', 'triangulé', 'triangulate');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (12, true, 'gantry', 'portique', 'gantry');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (13, true, 'lamppost', 'candélabre', 'lamppost');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (14, true, 'jib', 'potence', 'jib');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (15, true, 'facade', 'façade', 'facade');
INSERT INTO signalo_vl.support_type (id, active, value_en, value_fr, value_de) VALUES (16, true, 'wall', 'mur', 'wall');


--
-- Name: coating_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.coating_id_seq', 1, false);


--
-- Name: durability_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.durability_id_seq', 1, false);


--
-- Name: frame_fixing_type_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.frame_fixing_type_id_seq', 1, false);


--
-- Name: frame_type_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.frame_type_id_seq', 1, false);


--
-- Name: lighting_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.lighting_id_seq', 1, false);


--
-- Name: marker_type_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.marker_type_id_seq', 1, false);


--
-- Name: mirror_shape_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.mirror_shape_id_seq', 1, false);


--
-- Name: sign_type_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.sign_type_id_seq', 1, false);


--
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.status_id_seq', 1, false);


--
-- Name: support_base_type_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.support_base_type_id_seq', 1, false);


--
-- Name: support_type_id_seq; Type: SEQUENCE SET; Schema: signalo_vl; Owner: postgres
--

SELECT pg_catalog.setval('signalo_vl.support_type_id_seq', 1, false);


--
-- Name: azimut azimut_fk_support_azimut_key; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.azimut
    ADD CONSTRAINT azimut_fk_support_azimut_key UNIQUE (fk_support, azimut) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: azimut azimut_pkey; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.azimut
    ADD CONSTRAINT azimut_pkey PRIMARY KEY (id);


--
-- Name: frame frame_fk_azimut_rank_key; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.frame
    ADD CONSTRAINT frame_fk_azimut_rank_key UNIQUE (fk_azimut, rank) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: frame frame_pkey; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.frame
    ADD CONSTRAINT frame_pkey PRIMARY KEY (id);


--
-- Name: owner owner_pkey; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.owner
    ADD CONSTRAINT owner_pkey PRIMARY KEY (id);


--
-- Name: provider provider_pkey; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.provider
    ADD CONSTRAINT provider_pkey PRIMARY KEY (id);


--
-- Name: sign sign_fk_frame_rank_verso_key; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT sign_fk_frame_rank_verso_key UNIQUE (fk_frame, rank, verso) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sign sign_pkey; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT sign_pkey PRIMARY KEY (id);


--
-- Name: support support_pkey; Type: CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.support
    ADD CONSTRAINT support_pkey PRIMARY KEY (id);


--
-- Name: coating coating_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.coating
    ADD CONSTRAINT coating_pkey PRIMARY KEY (id);


--
-- Name: durability durability_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.durability
    ADD CONSTRAINT durability_pkey PRIMARY KEY (id);


--
-- Name: frame_fixing_type frame_fixing_type_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.frame_fixing_type
    ADD CONSTRAINT frame_fixing_type_pkey PRIMARY KEY (id);


--
-- Name: frame_type frame_type_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.frame_type
    ADD CONSTRAINT frame_type_pkey PRIMARY KEY (id);


--
-- Name: lighting lighting_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.lighting
    ADD CONSTRAINT lighting_pkey PRIMARY KEY (id);


--
-- Name: marker_type marker_type_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.marker_type
    ADD CONSTRAINT marker_type_pkey PRIMARY KEY (id);


--
-- Name: mirror_shape mirror_shape_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.mirror_shape
    ADD CONSTRAINT mirror_shape_pkey PRIMARY KEY (id);


--
-- Name: official_sign official_sign_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.official_sign
    ADD CONSTRAINT official_sign_pkey PRIMARY KEY (id);


--
-- Name: sign_type sign_type_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.sign_type
    ADD CONSTRAINT sign_type_pkey PRIMARY KEY (id);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- Name: support_base_type support_base_type_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.support_base_type
    ADD CONSTRAINT support_base_type_pkey PRIMARY KEY (id);


--
-- Name: support_type support_type_pkey; Type: CONSTRAINT; Schema: signalo_vl; Owner: postgres
--

ALTER TABLE ONLY signalo_vl.support_type
    ADD CONSTRAINT support_type_pkey PRIMARY KEY (id);


--
-- Name: frame tr_frame_on_delete_reorder; Type: TRIGGER; Schema: signalo_od; Owner: postgres
--

CREATE TRIGGER tr_frame_on_delete_reorder AFTER DELETE ON signalo_od.frame FOR EACH ROW EXECUTE PROCEDURE signalo_od.ft_reorder_frames_on_support();


--
-- Name: TRIGGER tr_frame_on_delete_reorder ON frame; Type: COMMENT; Schema: signalo_od; Owner: postgres
--

COMMENT ON TRIGGER tr_frame_on_delete_reorder ON signalo_od.frame IS 'Trigger: update frames order after deleting one.';


--
-- Name: frame tr_frame_on_update_azimut_reorder; Type: TRIGGER; Schema: signalo_od; Owner: postgres
--

CREATE TRIGGER tr_frame_on_update_azimut_reorder AFTER UPDATE OF fk_azimut ON signalo_od.frame FOR EACH ROW WHEN ((old.fk_azimut <> new.fk_azimut)) EXECUTE PROCEDURE signalo_od.ft_reorder_frames_on_support();


--
-- Name: TRIGGER tr_frame_on_update_azimut_reorder ON frame; Type: COMMENT; Schema: signalo_od; Owner: postgres
--

COMMENT ON TRIGGER tr_frame_on_update_azimut_reorder ON signalo_od.frame IS 'Trigger: update frames order after changing azimut.';


--
-- Name: frame tr_frame_on_update_azimut_reorder_prepare; Type: TRIGGER; Schema: signalo_od; Owner: postgres
--

CREATE TRIGGER tr_frame_on_update_azimut_reorder_prepare BEFORE UPDATE OF fk_azimut ON signalo_od.frame FOR EACH ROW WHEN ((old.fk_azimut <> new.fk_azimut)) EXECUTE PROCEDURE signalo_od.ft_reorder_frames_on_support_put_last();


--
-- Name: TRIGGER tr_frame_on_update_azimut_reorder_prepare ON frame; Type: COMMENT; Schema: signalo_od; Owner: postgres
--

COMMENT ON TRIGGER tr_frame_on_update_azimut_reorder_prepare ON signalo_od.frame IS 'Trigger: after changing azimut, adapt rank be last on new azimut';


--
-- Name: sign tr_sign_on_delete_reorder; Type: TRIGGER; Schema: signalo_od; Owner: postgres
--

CREATE TRIGGER tr_sign_on_delete_reorder AFTER DELETE ON signalo_od.sign FOR EACH ROW EXECUTE PROCEDURE signalo_od.ft_reorder_signs_in_frame();


--
-- Name: TRIGGER tr_sign_on_delete_reorder ON sign; Type: COMMENT; Schema: signalo_od; Owner: postgres
--

COMMENT ON TRIGGER tr_sign_on_delete_reorder ON signalo_od.sign IS 'Trigger: update signs order after deleting one.';


--
-- Name: sign tr_sign_on_update_prevent_fk_frame; Type: TRIGGER; Schema: signalo_od; Owner: postgres
--

CREATE TRIGGER tr_sign_on_update_prevent_fk_frame BEFORE UPDATE OF fk_frame ON signalo_od.sign FOR EACH ROW WHEN ((new.fk_frame <> old.fk_frame)) EXECUTE PROCEDURE signalo_od.ft_sign_prevent_fk_frame_update();


--
-- Name: frame fkey_od_azimut; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.frame
    ADD CONSTRAINT fkey_od_azimut FOREIGN KEY (fk_azimut) REFERENCES signalo_od.azimut(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sign fkey_od_frame; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_od_frame FOREIGN KEY (fk_frame) REFERENCES signalo_od.frame(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: support fkey_od_owner; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.support
    ADD CONSTRAINT fkey_od_owner FOREIGN KEY (fk_owner) REFERENCES signalo_od.owner(id) MATCH FULL;


--
-- Name: sign fkey_od_owner; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_od_owner FOREIGN KEY (fk_owner) REFERENCES signalo_od.owner(id) MATCH FULL;


--
-- Name: support fkey_od_provider; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.support
    ADD CONSTRAINT fkey_od_provider FOREIGN KEY (fk_provider) REFERENCES signalo_od.provider(id) MATCH FULL;


--
-- Name: frame fkey_od_provider; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.frame
    ADD CONSTRAINT fkey_od_provider FOREIGN KEY (fk_provider) REFERENCES signalo_od.provider(id) MATCH FULL;


--
-- Name: sign fkey_od_provider; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_od_provider FOREIGN KEY (fk_provider) REFERENCES signalo_od.provider(id) MATCH FULL;


--
-- Name: sign fkey_od_sign; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_od_sign FOREIGN KEY (fk_parent) REFERENCES signalo_od.sign(id) MATCH FULL ON DELETE SET NULL;


--
-- Name: azimut fkey_od_support; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.azimut
    ADD CONSTRAINT fkey_od_support FOREIGN KEY (fk_support) REFERENCES signalo_od.support(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sign fkey_vl_coating; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_vl_coating FOREIGN KEY (fk_coating) REFERENCES signalo_vl.coating(id) MATCH FULL;


--
-- Name: sign fkey_vl_durability; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_vl_durability FOREIGN KEY (fk_durability) REFERENCES signalo_vl.durability(id) MATCH FULL;


--
-- Name: frame fkey_vl_frame_fixing_type; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.frame
    ADD CONSTRAINT fkey_vl_frame_fixing_type FOREIGN KEY (fk_frame_fixing_type) REFERENCES signalo_vl.frame_fixing_type(id) MATCH FULL;


--
-- Name: frame fkey_vl_frame_type; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.frame
    ADD CONSTRAINT fkey_vl_frame_type FOREIGN KEY (fk_frame_type) REFERENCES signalo_vl.frame_type(id) MATCH FULL;


--
-- Name: sign fkey_vl_lighting; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_vl_lighting FOREIGN KEY (fk_lighting) REFERENCES signalo_vl.lighting(id) MATCH FULL;


--
-- Name: sign fkey_vl_marker_type; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_vl_marker_type FOREIGN KEY (fk_marker_type) REFERENCES signalo_vl.marker_type(id) MATCH FULL;


--
-- Name: sign fkey_vl_mirror_shape; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_vl_mirror_shape FOREIGN KEY (fk_mirror_shape) REFERENCES signalo_vl.mirror_shape(id) MATCH FULL;


--
-- Name: sign fkey_vl_official_sign; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_vl_official_sign FOREIGN KEY (fk_official_sign) REFERENCES signalo_vl.official_sign(id) MATCH FULL;


--
-- Name: sign fkey_vl_sign_type; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_vl_sign_type FOREIGN KEY (fk_sign_type) REFERENCES signalo_vl.sign_type(id) MATCH FULL;


--
-- Name: support fkey_vl_status; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.support
    ADD CONSTRAINT fkey_vl_status FOREIGN KEY (fk_status) REFERENCES signalo_vl.status(id) MATCH FULL;


--
-- Name: frame fkey_vl_status; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.frame
    ADD CONSTRAINT fkey_vl_status FOREIGN KEY (fk_status) REFERENCES signalo_vl.status(id) MATCH FULL;


--
-- Name: sign fkey_vl_status; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.sign
    ADD CONSTRAINT fkey_vl_status FOREIGN KEY (fk_status) REFERENCES signalo_vl.status(id) MATCH FULL;


--
-- Name: support fkey_vl_support_base_type; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.support
    ADD CONSTRAINT fkey_vl_support_base_type FOREIGN KEY (fk_support_base_type) REFERENCES signalo_vl.support_base_type(id) MATCH FULL;


--
-- Name: support fkey_vl_support_type; Type: FK CONSTRAINT; Schema: signalo_od; Owner: postgres
--

ALTER TABLE ONLY signalo_od.support
    ADD CONSTRAINT fkey_vl_support_type FOREIGN KEY (fk_support_type) REFERENCES signalo_vl.support_type(id) MATCH FULL;


--
-- PostgreSQL database dump complete
--

