--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Debian 16.9-1.pgdg120+1)
-- Dumped by pg_dump version 16.9 (Debian 16.9-1.pgdg120+1)

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
-- Name: update_epoch_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_epoch_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at_epoch = (select ((EXTRACT(epoch FROM CURRENT_TIMESTAMP))::bigint * 1000));
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_epoch_updated_at_column() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at= now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: inventory_registry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_registry (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    workspace_timezone character varying(25) NOT NULL,
    inventory_uuid character varying(40) NOT NULL,
    name character varying(100) NOT NULL,
    unit character varying(20) NOT NULL,
    total_stock character varying(20) NOT NULL,
    reorder_point character varying(20) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    utc_hour_for_8am smallint NOT NULL,
    utc_min_for_8am smallint NOT NULL,
    track_inventory boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    inventory_id bigint NOT NULL
);


ALTER TABLE public.inventory_registry OWNER TO postgres;

--
-- Name: organisation_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisation_users (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    user_id bigint NOT NULL,
    role smallint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.organisation_users OWNER TO postgres;

--
-- Name: organisation_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organisation_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organisation_users_id_seq OWNER TO postgres;

--
-- Name: organisation_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organisation_users_id_seq OWNED BY public.organisation_users.id;


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisations (
    org_id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    name character varying(100) NOT NULL,
    subdomain character varying(15) NOT NULL,
    fqdn character varying(50) NOT NULL,
    subscription_plan integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    active boolean DEFAULT true NOT NULL,
    custom_logo boolean DEFAULT false NOT NULL,
    logo_uuid character varying(40) DEFAULT gen_random_uuid() NOT NULL,
    favicon_uuid character varying(40) DEFAULT gen_random_uuid() NOT NULL,
    email_from character varying(150) DEFAULT 'noreply@statstream.app'::character varying NOT NULL,
    custom_favicon boolean DEFAULT false NOT NULL,
    full_whitelabel boolean DEFAULT false NOT NULL
);


ALTER TABLE public.organisations OWNER TO postgres;

--
-- Name: organisations_org_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organisations_org_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organisations_org_id_seq OWNER TO postgres;

--
-- Name: organisations_org_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organisations_org_id_seq OWNED BY public.organisations.org_id;


--
-- Name: reports_registry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports_registry (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    report_uuid character varying(40) NOT NULL,
    active boolean NOT NULL,
    send_report_at_hours smallint NOT NULL,
    data_for_past_hours smallint NOT NULL,
    time_zone character varying(100) NOT NULL,
    report_scheduler_type character varying(10) NOT NULL,
    schedule_report_date_of_month character varying(40) NOT NULL,
    run_at_hours_utc smallint NOT NULL,
    run_at_minutes_utc smallint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.reports_registry OWNER TO postgres;

--
-- Name: rooms_security; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms_security (
    uuid character varying(40) NOT NULL,
    room_uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    security_code character varying(20) NOT NULL,
    checkout_date character varying(30) NOT NULL,
    checkout_time integer NOT NULL,
    utc_checkout_date timestamp without time zone NOT NULL,
    checked_in boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    room_code character varying(40) NOT NULL,
    utc_checkout_hrs integer DEFAULT 0 NOT NULL,
    utc_checkout_mins integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.rooms_security OWNER TO postgres;

--
-- Name: scheduler_registry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scheduler_registry (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    scheduler_uuid character varying(40) NOT NULL,
    action_uuid character varying(40) NOT NULL,
    scheduler_type character varying(10) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    schedule_action_at_hours smallint NOT NULL,
    time_zone character varying(100) NOT NULL,
    schedule_action_at_weekday character varying(10) NOT NULL,
    schedule_action_date_of_month character varying(40) NOT NULL,
    run_at_hours_utc smallint NOT NULL,
    run_at_minutes_utc smallint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    schedule_action_month character varying(20) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.scheduler_registry OWNER TO postgres;

--
-- Name: tickets_registry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets_registry (
    org_id bigint NOT NULL,
    org_uuid character varying(40) NOT NULL,
    workspace_id bigint NOT NULL,
    workspace_uuid character varying(40) NOT NULL,
    ticket_id bigint NOT NULL,
    ticket_uuid character varying(40) NOT NULL,
    ticket_status character varying(50) NOT NULL,
    due_utc_hour smallint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    due_utc_min smallint DEFAULT 0 NOT NULL,
    due_utc_day smallint DEFAULT 0 NOT NULL,
    due_date_utc timestamp without time zone DEFAULT now() NOT NULL,
    id bigint NOT NULL,
    ticket_type character varying(50) DEFAULT 'WORK_ORDER'::character varying NOT NULL
);


ALTER TABLE public.tickets_registry OWNER TO postgres;

--
-- Name: tickets_registry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tickets_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tickets_registry_id_seq OWNER TO postgres;

--
-- Name: tickets_registry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tickets_registry_id_seq OWNED BY public.tickets_registry.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    gip_uid character varying(50),
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email_valid boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true,
    phone_number character varying(50) DEFAULT ''::character varying NOT NULL,
    theme character varying(10) DEFAULT 'light'::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: workspace_tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_tickets (
    id bigint NOT NULL,
    ticket_id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    asset_uuid character varying(40) NOT NULL,
    ticket_type character varying(50) NOT NULL,
    title character varying(140) NOT NULL,
    description text NOT NULL,
    completion_time_mins bigint NOT NULL,
    due_date character varying(50) NOT NULL,
    severity character varying(100) NOT NULL,
    assigned_to character varying(100) NOT NULL,
    ticket_status character varying(50) NOT NULL,
    created_by_user character varying(50) DEFAULT ''::character varying NOT NULL,
    team_assigned character varying(50) DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ticket_category character varying(100) DEFAULT ''::character varying NOT NULL,
    asset_id bigint DEFAULT 0 NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    assignee_role bigint DEFAULT 0 NOT NULL,
    done_time bigint DEFAULT 0 NOT NULL,
    utc_due_date timestamp without time zone DEFAULT now() NOT NULL,
    utc_done_time timestamp without time zone DEFAULT now() NOT NULL,
    utc_open_time timestamp without time zone,
    checklist_uuids text[] DEFAULT '{}'::text[] NOT NULL
);


ALTER TABLE public.workspace_tickets OWNER TO postgres;

--
-- Name: user_ticket_counts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.user_ticket_counts AS
 SELECT u.id AS user_id,
    u.name AS user_name,
    wt.org_id,
    wt.workspace_id,
    count(wt.id) AS ticket_count
   FROM (public.users u
     JOIN public.workspace_tickets wt ON (((u.uuid)::text = (wt.assigned_to)::text)))
  WHERE ((wt.ticket_status)::text <> ALL (ARRAY[('DONE'::character varying)::text, ('REJECTED'::character varying)::text]))
  GROUP BY u.id, u.name, wt.org_id, wt.workspace_id;


ALTER VIEW public.user_ticket_counts OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: workspace_action_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_action_schedule (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(250) NOT NULL,
    action_uuid character varying(40) NOT NULL,
    scheduler_type character varying(10) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    schedule_action_at_hours smallint NOT NULL,
    schedule_action_at_weekday character varying(10) NOT NULL,
    schedule_action_date_of_month character varying(40) NOT NULL,
    run_at_hours_utc smallint NOT NULL,
    run_at_minutes_utc smallint NOT NULL,
    time_zone character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    schedule_action_month character varying(20) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_action_schedule OWNER TO postgres;

--
-- Name: workspace_actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_actions (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    action_type character varying(40) NOT NULL,
    action_name character varying(250) NOT NULL,
    action_description character varying(250) DEFAULT ''::character varying NOT NULL,
    action_config json DEFAULT '{}'::json NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    action_content text DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_actions OWNER TO postgres;

--
-- Name: workspace_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_alerts (
    uuid character varying(40) NOT NULL,
    serial_number bigint NOT NULL,
    subject character varying(255) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    rule_uuid character varying(40) NOT NULL,
    status integer NOT NULL,
    comment character varying(100) NOT NULL,
    acknowledge_timestamp bigint NOT NULL,
    acknowledge_by character varying(150) NOT NULL,
    severity character varying(15) NOT NULL,
    violation_value character varying(100) DEFAULT 0 NOT NULL,
    created_at_epoch bigint DEFAULT ((EXTRACT(epoch FROM CURRENT_TIMESTAMP))::bigint * 1000) NOT NULL,
    updated_at_epoch bigint DEFAULT ((EXTRACT(epoch FROM CURRENT_TIMESTAMP))::bigint * 1000) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    variable_identifier character varying(50) NOT NULL
);


ALTER TABLE public.workspace_alerts OWNER TO postgres;

--
-- Name: workspace_amenities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_amenities (
    id integer NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(500) NOT NULL,
    location character varying(500) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    timing character varying(40) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.workspace_amenities OWNER TO postgres;

--
-- Name: workspace_amenities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_amenities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_amenities_id_seq OWNER TO postgres;

--
-- Name: workspace_amenities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_amenities_id_seq OWNED BY public.workspace_amenities.id;


--
-- Name: workspace_assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_assets (
    id bigint NOT NULL,
    asset_id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    asset_tag character varying(100) NOT NULL,
    asset_name character varying(50) NOT NULL,
    asset_type_uuid character varying(50) NOT NULL,
    ticket_id character varying(100) NOT NULL,
    status character varying(100) NOT NULL,
    serial_number character varying(100) NOT NULL,
    manufacturer character varying(50) NOT NULL,
    criticality character varying(50) NOT NULL,
    description character varying(250) NOT NULL,
    manufacturing_date character varying(50) NOT NULL,
    commissioning_date character varying(50) NOT NULL,
    model character varying(100) DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    location_uuid character varying(50) DEFAULT ''::character varying NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    company_uuid character varying(40) DEFAULT ''::character varying NOT NULL,
    asset_owner character varying(100) DEFAULT ''::character varying NOT NULL,
    purchase_order_no character varying(100) DEFAULT ''::character varying NOT NULL,
    decommissioning_date character varying(50) DEFAULT ''::character varying NOT NULL,
    purchase_date character varying(50) DEFAULT ''::character varying NOT NULL,
    warranty_end_date character varying(50) DEFAULT ''::character varying NOT NULL,
    contract_company_uuids text[] DEFAULT '{}'::text[] NOT NULL,
    utc_manufacturing_date timestamp without time zone,
    utc_commissioning_date timestamp without time zone,
    utc_decommissioning_date timestamp without time zone,
    utc_purchase_date timestamp without time zone,
    utc_warranty_end_date timestamp without time zone,
    asset_cost character varying(20) DEFAULT ''::character varying NOT NULL,
    salvage_value character varying(20) DEFAULT ''::character varying NOT NULL,
    useful_life bigint DEFAULT 0 NOT NULL,
    depreciation_method character varying(50) DEFAULT ''::character varying NOT NULL,
    depreciation_rate bigint DEFAULT 0 NOT NULL,
    parent_asset character varying(40) DEFAULT ''::character varying NOT NULL,
    approval_required boolean DEFAULT false NOT NULL,
    internal_type smallint DEFAULT '10'::smallint NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.workspace_assets OWNER TO postgres;

--
-- Name: workspace_assets_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_assets_types (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    asset_type character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    internal_type smallint DEFAULT '10'::smallint NOT NULL
);


ALTER TABLE public.workspace_assets_types OWNER TO postgres;

--
-- Name: workspace_asset_type_summary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.workspace_asset_type_summary AS
 SELECT at.asset_type,
    at.org_id,
    at.workspace_id,
    count(t.id) AS ticket_count
   FROM ((public.workspace_assets_types at
     LEFT JOIN public.workspace_assets a ON (((at.uuid)::text = (a.asset_type_uuid)::text)))
     LEFT JOIN public.workspace_tickets t ON ((((a.uuid)::text = (t.asset_uuid)::text) AND ((t.ticket_status)::text <> 'DONE'::text))))
  GROUP BY at.asset_type, at.org_id, at.workspace_id;


ALTER VIEW public.workspace_asset_type_summary OWNER TO postgres;

--
-- Name: workspace_asset_work_order_count; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.workspace_asset_work_order_count AS
 SELECT wa.asset_name,
    wa.uuid,
    wa.org_id,
    wa.workspace_id,
    wa.internal_type,
    count(wt.id) AS ticket_count
   FROM (public.workspace_assets wa
     LEFT JOIN public.workspace_tickets wt ON (((wa.asset_id = wt.asset_id) AND (wa.workspace_id = wt.workspace_id) AND (wa.org_id = wt.org_id) AND ((wt.ticket_status)::text <> 'DONE'::text))))
  GROUP BY wa.asset_name, wa.uuid, wa.org_id, wa.workspace_id, wa.internal_type;


ALTER VIEW public.workspace_asset_work_order_count OWNER TO postgres;

--
-- Name: workspace_assets_criticalities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_assets_criticalities (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    criticality_name character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_assets_criticalities OWNER TO postgres;

--
-- Name: workspace_assets_criticalities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_assets_criticalities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_assets_criticalities_id_seq OWNER TO postgres;

--
-- Name: workspace_assets_criticalities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_assets_criticalities_id_seq OWNED BY public.workspace_assets_criticalities.id;


--
-- Name: workspace_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_assets_id_seq OWNER TO postgres;

--
-- Name: workspace_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_assets_id_seq OWNED BY public.workspace_assets.id;


--
-- Name: workspace_assets_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_assets_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_assets_types_id_seq OWNER TO postgres;

--
-- Name: workspace_assets_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_assets_types_id_seq OWNED BY public.workspace_assets_types.id;


--
-- Name: workspace_nearby_attraction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_nearby_attraction (
    id integer NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(500) NOT NULL,
    location character varying(500) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    timing character varying(40) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    map_url character varying(500) DEFAULT 'https://www.google.com/maps'::character varying NOT NULL
);


ALTER TABLE public.workspace_nearby_attraction OWNER TO postgres;

--
-- Name: workspace_attraction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_attraction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_attraction_id_seq OWNER TO postgres;

--
-- Name: workspace_attraction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_attraction_id_seq OWNED BY public.workspace_nearby_attraction.id;


--
-- Name: workspace_cabs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_cabs (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    cab_request_id bigint NOT NULL,
    destination character varying(100) NOT NULL,
    cab_type character varying(100) NOT NULL,
    timing character varying(40) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    room_uuid character varying(40) NOT NULL,
    ticket_uuid character varying(40) NOT NULL,
    guest_name character varying(250) DEFAULT ''::character varying NOT NULL,
    guest_phone character varying(250) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_cabs OWNER TO postgres;

--
-- Name: workspace_checklist_item_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_checklist_item_categories (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    category_name character varying(100) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_checklist_item_categories OWNER TO postgres;

--
-- Name: workspace_checklist_item_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_checklist_item_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_checklist_item_categories_id_seq OWNER TO postgres;

--
-- Name: workspace_checklist_item_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_checklist_item_categories_id_seq OWNED BY public.workspace_checklist_item_categories.id;


--
-- Name: workspace_checklist_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_checklist_items (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    checklist_uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    item_category_uuid character varying(40) NOT NULL,
    item_md text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    item_html text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.workspace_checklist_items OWNER TO postgres;

--
-- Name: workspace_checklist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_checklist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_checklist_items_id_seq OWNER TO postgres;

--
-- Name: workspace_checklist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_checklist_items_id_seq OWNED BY public.workspace_checklist_items.id;


--
-- Name: workspace_checklist_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_checklist_records (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    checklist_uuid character varying(40) NOT NULL,
    checklist_item_uuid character varying(40) NOT NULL,
    ticket_uuid character varying(40) NOT NULL,
    is_done boolean DEFAULT false NOT NULL,
    observation text NOT NULL,
    action_taken text NOT NULL,
    status character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_checklist_records OWNER TO postgres;

--
-- Name: workspace_checklist_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_checklist_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_checklist_records_id_seq OWNER TO postgres;

--
-- Name: workspace_checklist_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_checklist_records_id_seq OWNED BY public.workspace_checklist_records.id;


--
-- Name: workspace_checklists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_checklists (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    asset_type_uuid character varying(40) NOT NULL,
    name character varying(250) NOT NULL,
    description character varying(250) DEFAULT ''::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_checklists OWNER TO postgres;

--
-- Name: workspace_checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_checklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_checklists_id_seq OWNER TO postgres;

--
-- Name: workspace_checklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_checklists_id_seq OWNED BY public.workspace_checklists.id;


--
-- Name: workspace_company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_company_id_seq OWNER TO postgres;

--
-- Name: workspace_companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_companies (
    id bigint DEFAULT nextval('public.workspace_company_id_seq'::regclass) NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    company_name character varying(150) NOT NULL,
    address_line_1 character varying(250) NOT NULL,
    address_line_2 character varying(250) NOT NULL,
    city character varying(150) NOT NULL,
    state character varying(200) NOT NULL,
    country character varying(250) NOT NULL,
    contact_number_1 character varying(20) NOT NULL,
    contact_number_2 character varying(20) NOT NULL,
    contact_number_3 character varying(20) NOT NULL,
    additional_details character varying(500) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email_1 character varying(150) DEFAULT ''::character varying NOT NULL,
    email_2 character varying(150) DEFAULT ''::character varying NOT NULL,
    email_3 character varying(150) DEFAULT ''::character varying NOT NULL,
    company_status character varying(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
    company_type character varying(50) DEFAULT ''::character varying NOT NULL,
    tax_id character varying(30) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_companies OWNER TO postgres;

--
-- Name: workspace_contract_assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_contract_assets (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    workspace_id bigint NOT NULL,
    org_id bigint NOT NULL,
    asset_uuid character varying(40) NOT NULL,
    contract_uuid character varying(40) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    company_uuid character varying(40) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_contract_assets OWNER TO postgres;

--
-- Name: workspace_contract_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_contract_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_contract_assets_id_seq OWNER TO postgres;

--
-- Name: workspace_contract_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_contract_assets_id_seq OWNED BY public.workspace_contract_assets.id;


--
-- Name: workspace_csp_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_csp_settings (
    id integer NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    setting_key character varying(100) NOT NULL,
    setting_value text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_csp_settings OWNER TO postgres;

--
-- Name: workspace_csp_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_csp_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_csp_settings_id_seq OWNER TO postgres;

--
-- Name: workspace_csp_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_csp_settings_id_seq OWNED BY public.workspace_csp_settings.id;


--
-- Name: workspace_dashboard_widgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_dashboard_widgets (
    id character varying(40) NOT NULL,
    chart_type character varying(20) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    org_id bigint NOT NULL,
    dashboard_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    config json DEFAULT '{}'::json NOT NULL,
    horizontal_size character varying(10) DEFAULT '3'::character varying NOT NULL,
    vertical_size character varying(10) DEFAULT 'main'::character varying NOT NULL,
    title character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_dashboard_widgets OWNER TO postgres;

--
-- Name: workspace_dashboard_widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_dashboard_widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_dashboard_widgets_id_seq OWNER TO postgres;

--
-- Name: workspace_dashboard_widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_dashboard_widgets_id_seq OWNED BY public.workspace_dashboard_widgets.id;


--
-- Name: workspace_dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_dashboards (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    name character varying(25) NOT NULL,
    workspace_id bigint NOT NULL,
    org_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    widgets_order json DEFAULT '{}'::json NOT NULL,
    parent_dashboard character varying(40) DEFAULT ''::character varying NOT NULL,
    description character varying(250) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_dashboards OWNER TO postgres;

--
-- Name: workspace_dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_dashboards_id_seq OWNER TO postgres;

--
-- Name: workspace_dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_dashboards_id_seq OWNED BY public.workspace_dashboards.id;


--
-- Name: workspace_devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_devices (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    name character varying(25) NOT NULL,
    workspace_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    org_id bigint NOT NULL,
    identifier character varying(50) NOT NULL,
    description character varying(250) NOT NULL,
    "default" boolean DEFAULT false NOT NULL,
    sites_uuid character varying(40) DEFAULT ''::character varying NOT NULL,
    enabled_transformation boolean DEFAULT false NOT NULL,
    transformation_script text DEFAULT 'return JSON.stringify(payload);'::text NOT NULL
);


ALTER TABLE public.workspace_devices OWNER TO postgres;

--
-- Name: workspace_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_devices_id_seq OWNER TO postgres;

--
-- Name: workspace_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_devices_id_seq OWNED BY public.workspace_devices.id;


--
-- Name: workspace_energy_bills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_energy_bills (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    bill_name character varying(200) NOT NULL,
    file_name character varying(200) NOT NULL,
    bill_month smallint NOT NULL,
    bill_year smallint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_energy_bills OWNER TO postgres;

--
-- Name: workspace_faqs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_faqs (
    id integer NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    question text NOT NULL,
    answer character varying(500) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.workspace_faqs OWNER TO postgres;

--
-- Name: workspace_faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_faqs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_faqs_id_seq OWNER TO postgres;

--
-- Name: workspace_faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_faqs_id_seq OWNED BY public.workspace_faqs.id;


--
-- Name: workspace_feedback_question_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_feedback_question_categories (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    form_uuid character varying(40) NOT NULL,
    category_name character varying(250) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.workspace_feedback_question_categories OWNER TO postgres;

--
-- Name: workspace_feedback_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_feedback_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_feedback_categories_id_seq OWNER TO postgres;

--
-- Name: workspace_feedback_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_feedback_categories_id_seq OWNED BY public.workspace_feedback_question_categories.id;


--
-- Name: workspace_feedback_forms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_feedback_forms (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    show_guest_name boolean DEFAULT true NOT NULL,
    show_guest_email boolean DEFAULT false NOT NULL,
    show_guest_phone boolean DEFAULT false NOT NULL,
    show_guest_dob boolean DEFAULT false NOT NULL,
    show_guest_anniversary boolean DEFAULT false NOT NULL,
    show_guest_stay_purpose boolean DEFAULT false NOT NULL,
    show_additional_comments boolean DEFAULT true NOT NULL
);


ALTER TABLE public.workspace_feedback_forms OWNER TO postgres;

--
-- Name: workspace_feedback_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_feedback_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_feedback_forms_id_seq OWNER TO postgres;

--
-- Name: workspace_feedback_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_feedback_forms_id_seq OWNED BY public.workspace_feedback_forms.id;


--
-- Name: workspace_feedback_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_feedback_questions (
    id bigint NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    form_uuid character varying(40) NOT NULL,
    question_uuid character varying(40) NOT NULL,
    category_uuid character varying(40) NOT NULL,
    question_text character varying(500) NOT NULL,
    question_type character varying(50) DEFAULT 'multiple_choice'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    display_order integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.workspace_feedback_questions OWNER TO postgres;

--
-- Name: workspace_feedback_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_feedback_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_feedback_questions_id_seq OWNER TO postgres;

--
-- Name: workspace_feedback_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_feedback_questions_id_seq OWNED BY public.workspace_feedback_questions.id;


--
-- Name: workspace_feedback_responses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_feedback_responses (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    session_uuid character varying(40) NOT NULL,
    question_uuid character varying(40) NOT NULL,
    response_text text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_feedback_responses OWNER TO postgres;

--
-- Name: workspace_feedback_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_feedback_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_feedback_responses_id_seq OWNER TO postgres;

--
-- Name: workspace_feedback_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_feedback_responses_id_seq OWNED BY public.workspace_feedback_responses.id;


--
-- Name: workspace_feedback_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_feedback_sessions (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    form_uuid character varying(40) NOT NULL,
    guest_name character varying(100) NOT NULL,
    guest_email character varying(100) NOT NULL,
    guest_phone character varying(20) NOT NULL,
    guest_dob character varying(20) NOT NULL,
    guest_anniversary character varying(20) NOT NULL,
    guest_stay_purpose character varying(100) NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    additional_comments character varying(500) DEFAULT ''::character varying NOT NULL,
    room_uuid character varying(40) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_feedback_sessions OWNER TO postgres;

--
-- Name: workspace_feedback_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_feedback_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_feedback_sessions_id_seq OWNER TO postgres;

--
-- Name: workspace_feedback_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_feedback_sessions_id_seq OWNED BY public.workspace_feedback_sessions.id;


--
-- Name: workspace_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_files (
    file_id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    object_uuid character varying(40) NOT NULL,
    object_type character varying(20) NOT NULL,
    file_name character varying(100) NOT NULL,
    file_description character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    uploaded_by character varying(100) DEFAULT ''::character varying NOT NULL,
    file_privacy integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.workspace_files OWNER TO postgres;

--
-- Name: workspace_files_file_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_files_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_files_file_id_seq OWNER TO postgres;

--
-- Name: workspace_files_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_files_file_id_seq OWNED BY public.workspace_files.file_id;


--
-- Name: workspace_food_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_food_categories (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    category_name character varying(100) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_food_categories OWNER TO postgres;

--
-- Name: workspace_food_dishes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_food_dishes (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    dish_name character varying(100) NOT NULL,
    dish_code character varying(50) NOT NULL,
    description character varying(500) NOT NULL,
    dish_price character varying(20) NOT NULL,
    dish_tax character varying(10) NOT NULL,
    food_category_uuid character varying(40) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_food_dishes OWNER TO postgres;

--
-- Name: workspace_food_order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_food_order_items (
    uuid character varying(40) NOT NULL,
    food_order_uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    dish_uuid character varying(40) NOT NULL,
    dish_code character varying(50) NOT NULL,
    quantity integer NOT NULL,
    unit_price character varying(20) NOT NULL,
    total_amount character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tax_amount character varying(20) DEFAULT '0'::character varying NOT NULL
);


ALTER TABLE public.workspace_food_order_items OWNER TO postgres;

--
-- Name: workspace_food_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_food_orders (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    food_order_id bigint NOT NULL,
    room_uuid character varying(40) NOT NULL,
    total_order_value character varying(20) NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_tax_amount character varying(20) DEFAULT '0'::character varying NOT NULL,
    total_amount_with_tax character varying(20) DEFAULT '0'::character varying NOT NULL,
    ticket_uuid character varying(40) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_food_orders OWNER TO postgres;

--
-- Name: workspace_general_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_general_info (
    id integer NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    message text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_general_info OWNER TO postgres;

--
-- Name: workspace_general_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_general_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_general_info_id_seq OWNER TO postgres;

--
-- Name: workspace_general_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_general_info_id_seq OWNED BY public.workspace_general_info.id;


--
-- Name: workspace_hotel_emergency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_hotel_emergency (
    id integer NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    message text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.workspace_hotel_emergency OWNER TO postgres;

--
-- Name: workspace_hotel_emergency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_hotel_emergency_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_hotel_emergency_id_seq OWNER TO postgres;

--
-- Name: workspace_hotel_emergency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_hotel_emergency_id_seq OWNED BY public.workspace_hotel_emergency.id;


--
-- Name: workspace_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_images (
    image_id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    object_uuid character varying(40) NOT NULL,
    object_type character varying(20) NOT NULL,
    image_name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    uploaded_by character varying(100) DEFAULT ''::character varying NOT NULL,
    image_privacy integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.workspace_images OWNER TO postgres;

--
-- Name: workspace_images_image_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_images_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_images_image_id_seq OWNER TO postgres;

--
-- Name: workspace_images_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_images_image_id_seq OWNED BY public.workspace_images.image_id;


--
-- Name: workspace_ingress_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_ingress_credentials (
    id bigint NOT NULL,
    uuid character varying(50) NOT NULL,
    protocol character varying(10) NOT NULL,
    name character varying(25) NOT NULL,
    secret_key character varying(40) NOT NULL,
    workspace_id bigint NOT NULL,
    org_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description character varying(250) NOT NULL
);


ALTER TABLE public.workspace_ingress_credentials OWNER TO postgres;

--
-- Name: workspace_ingress_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_ingress_credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_ingress_credentials_id_seq OWNER TO postgres;

--
-- Name: workspace_ingress_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_ingress_credentials_id_seq OWNED BY public.workspace_ingress_credentials.id;


--
-- Name: workspace_inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_inventory (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(250) NOT NULL,
    type character varying(10) NOT NULL,
    sku character varying(100) NOT NULL,
    unit character varying(20) NOT NULL,
    manufacturer_uuid character varying(40) NOT NULL,
    brand character varying(100) NOT NULL,
    upc_number character varying(50),
    mpn_number character varying(50),
    ean_number character varying(50),
    isbn_number character varying(50),
    purchase_price character varying(20) NOT NULL,
    purchase_vendor_uuid character varying(40) NOT NULL,
    total_stock character varying(20) NOT NULL,
    reorder_point character varying(20) NOT NULL,
    valuation_method character varying(20) NOT NULL,
    opening_stock_rate_per_unit character varying(20) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    track_inventory boolean DEFAULT false NOT NULL,
    total_valuation character varying(30) NOT NULL,
    latest_purchase_price character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    inventory_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.workspace_inventory OWNER TO postgres;

--
-- Name: workspace_locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_locations (
    id bigint NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    sites_uuid character varying(40) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(250) NOT NULL,
    area character varying(50) NOT NULL,
    floor character varying(50) NOT NULL,
    building character varying(50) NOT NULL,
    room character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.workspace_locations OWNER TO postgres;

--
-- Name: workspace_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_locations_id_seq OWNER TO postgres;

--
-- Name: workspace_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_locations_id_seq OWNED BY public.workspace_locations.id;


--
-- Name: workspace_offers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_offers (
    id integer NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(500) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    end_date character varying(100) NOT NULL
);


ALTER TABLE public.workspace_offers OWNER TO postgres;

--
-- Name: workspace_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_offers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_offers_id_seq OWNER TO postgres;

--
-- Name: workspace_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_offers_id_seq OWNED BY public.workspace_offers.id;


--
-- Name: workspace_parts_received; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_parts_received (
    uuid character varying(40) NOT NULL,
    received_id bigint NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    inventory_uuid character varying(40) NOT NULL,
    purchase_vendor_uuid character varying(40) NOT NULL,
    received_quantity character varying(20) NOT NULL,
    unit character varying(20) NOT NULL,
    status_id smallint NOT NULL,
    received_date character varying(50) NOT NULL,
    utc_received_date timestamp without time zone DEFAULT now() NOT NULL,
    purchase_received_number character varying(50),
    purchase_order_number character varying(50),
    purchase_price character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_parts_received OWNER TO postgres;

--
-- Name: workspace_parts_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_parts_request (
    uuid character varying(40) NOT NULL,
    request_id bigint NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    ticket_uuid character varying(40) NOT NULL,
    inventory_uuid character varying(40) NOT NULL,
    requested_by character varying(100) NOT NULL,
    unit character varying(20) NOT NULL,
    status_id smallint NOT NULL,
    requested_quantity character varying(20) NOT NULL,
    return_quantity character varying(20) NOT NULL,
    is_delivered boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_parts_request OWNER TO postgres;

--
-- Name: workspace_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_reports (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(10) NOT NULL,
    data_for_past_hours smallint NOT NULL,
    send_report_at_hours smallint NOT NULL,
    time_zone character varying(100) NOT NULL,
    variables text[] NOT NULL,
    emails text[] NOT NULL,
    is_custom_template boolean NOT NULL,
    custom_template_id character varying(40) NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    sheet character varying(10) DEFAULT 'Data'::character varying NOT NULL,
    email1 character varying(250) DEFAULT ''::character varying NOT NULL,
    email2 character varying(250) DEFAULT ''::character varying NOT NULL,
    email3 character varying(250) DEFAULT ''::character varying NOT NULL,
    schedule_report_date_of_month character varying(40) DEFAULT 'all'::character varying NOT NULL,
    report_scheduler_type character varying(10) DEFAULT 'daily'::character varying NOT NULL,
    report_config json DEFAULT '{}'::json,
    round_off_timestamp character varying(10) DEFAULT 'disable'::character varying NOT NULL
);


ALTER TABLE public.workspace_reports OWNER TO postgres;

--
-- Name: COLUMN workspace_reports.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workspace_reports.name IS 'name of report';


--
-- Name: COLUMN workspace_reports.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workspace_reports.type IS 'type of report xls, pdf';


--
-- Name: workspace_restaurants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_restaurants (
    id integer NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(500) NOT NULL,
    location character varying(500) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    timing character varying(40) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.workspace_restaurants OWNER TO postgres;

--
-- Name: workspace_restaurants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_restaurants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_restaurants_id_seq OWNER TO postgres;

--
-- Name: workspace_restaurants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_restaurants_id_seq OWNED BY public.workspace_restaurants.id;


--
-- Name: workspace_room_item_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_room_item_categories (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    category_name character varying(100) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_room_item_categories OWNER TO postgres;

--
-- Name: workspace_room_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_room_items (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    item_name character varying(100) NOT NULL,
    item_code character varying(50) NOT NULL,
    description character varying(500) NOT NULL,
    item_price character varying(20) NOT NULL,
    item_tax character varying(10) NOT NULL,
    category_uuid character varying(40) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_room_items OWNER TO postgres;

--
-- Name: workspace_room_supply_request_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_room_supply_request_items (
    uuid character varying(40) NOT NULL,
    request_uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    item_uuid character varying(40) NOT NULL,
    item_code character varying(50) NOT NULL,
    quantity integer NOT NULL,
    unit_price character varying(20) NOT NULL,
    total_amount character varying(20) NOT NULL,
    tax_amount character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_room_supply_request_items OWNER TO postgres;

--
-- Name: workspace_room_supply_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_room_supply_requests (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    request_id bigint NOT NULL,
    room_uuid character varying(40) NOT NULL,
    total_items_amount character varying(20) NOT NULL,
    total_tax_amount character varying(20) NOT NULL,
    total_amount_with_tax character varying(20) NOT NULL,
    ticket_uuid character varying(40) NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_room_supply_requests OWNER TO postgres;

--
-- Name: workspace_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_rules (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(255) NOT NULL,
    variable_id character varying(40) NOT NULL,
    variable_uuid character varying(40) NOT NULL,
    condition character varying(20) NOT NULL,
    value_to_compare character varying(500) NOT NULL,
    notification character varying(20) DEFAULT 'no'::character varying NOT NULL,
    notification_data json DEFAULT '{}'::json NOT NULL,
    severity character varying(15) DEFAULT 'Info'::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    notification2 character varying(20) DEFAULT 'no'::character varying NOT NULL,
    notification_data2 json DEFAULT '{}'::json NOT NULL,
    notification3 character varying(20) DEFAULT 'no'::character varying NOT NULL,
    notification_data3 json DEFAULT '{}'::json NOT NULL,
    action1 character varying(40) DEFAULT ''::character varying NOT NULL,
    action2 character varying(40) DEFAULT ''::character varying NOT NULL,
    action3 character varying(40) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_rules OWNER TO postgres;

--
-- Name: COLUMN workspace_rules.org_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workspace_rules.org_id IS 'organisation id';


--
-- Name: COLUMN workspace_rules.workspace_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workspace_rules.workspace_id IS 'workspace id forrign key';


--
-- Name: COLUMN workspace_rules.notification; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workspace_rules.notification IS 'type of notification';


--
-- Name: workspace_service_contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_service_contracts (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    contract_id character varying(100) NOT NULL,
    contract_end_date character varying(50) NOT NULL,
    contract_start_date character varying(50) NOT NULL,
    company_uuid character varying(40) NOT NULL,
    additional_details character varying(500) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    contract_sign_by character varying(100) DEFAULT ''::character varying NOT NULL,
    remainder_email character varying(250) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    utc_contract_start_date timestamp without time zone DEFAULT now() NOT NULL,
    utc_contract_end_date timestamp without time zone DEFAULT now() NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.workspace_service_contracts OWNER TO postgres;

--
-- Name: workspace_service_contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_service_contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_service_contracts_id_seq OWNER TO postgres;

--
-- Name: workspace_service_contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_service_contracts_id_seq OWNED BY public.workspace_service_contracts.id;


--
-- Name: workspace_service_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_service_requests (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    request_id bigint NOT NULL,
    request_type character varying(250) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    room_uuid character varying(40) NOT NULL,
    ticket_uuid character varying(40) NOT NULL,
    request_details character varying(250) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_service_requests OWNER TO postgres;

--
-- Name: workspace_sites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_sites (
    uuid character varying(40) NOT NULL,
    name character varying(50) DEFAULT ''::character varying NOT NULL,
    latitude character varying(15) DEFAULT ''::character varying NOT NULL,
    longitude character varying(15) DEFAULT ''::character varying NOT NULL,
    address1 character varying(250) DEFAULT ''::character varying NOT NULL,
    address2 character varying(250) DEFAULT ''::character varying NOT NULL,
    city character varying(100) DEFAULT ''::character varying NOT NULL,
    state character varying(100) DEFAULT ''::character varying NOT NULL,
    country character varying(100) DEFAULT ''::character varying NOT NULL,
    workspace_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    org_id bigint NOT NULL,
    active boolean DEFAULT true NOT NULL,
    variable1 character varying(40) DEFAULT ''::character varying NOT NULL,
    variable2 character varying(40) DEFAULT ''::character varying NOT NULL,
    variable3 character varying(40) DEFAULT ''::character varying NOT NULL,
    dashboard_uuid character varying(40) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_sites OWNER TO postgres;

--
-- Name: workspace_team_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_team_members (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    user_uuid character varying(50) NOT NULL,
    team_uuid character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_team_members OWNER TO postgres;

--
-- Name: workspace_team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_team_members_id_seq OWNER TO postgres;

--
-- Name: workspace_team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_team_members_id_seq OWNED BY public.workspace_team_members.id;


--
-- Name: workspace_teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_teams (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    team_name character varying(50) NOT NULL,
    team_description character varying(500) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    team_owner character varying(40) DEFAULT ''::character varying NOT NULL,
    is_default_team boolean DEFAULT false NOT NULL
);


ALTER TABLE public.workspace_teams OWNER TO postgres;

--
-- Name: workspace_teams_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_teams_id_seq OWNER TO postgres;

--
-- Name: workspace_teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_teams_id_seq OWNED BY public.workspace_teams.id;


--
-- Name: workspace_ticket_summary_by_category; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.workspace_ticket_summary_by_category AS
 SELECT wa.asset_name,
    wt.asset_id,
    wt.org_id,
    wt.workspace_id,
    wt.ticket_category,
    count(*) AS count,
    max(wt.created_at) AS created_at
   FROM (public.workspace_tickets wt
     JOIN public.workspace_assets wa ON (((wa.asset_id = wt.asset_id) AND (wa.workspace_id = wt.workspace_id))))
  GROUP BY wa.asset_name, wt.asset_id, wt.org_id, wt.workspace_id, wt.ticket_category;


ALTER VIEW public.workspace_ticket_summary_by_category OWNER TO postgres;

--
-- Name: workspace_tickets_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_tickets_categories (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    categories_name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    categories_color text DEFAULT '#ffffff'::text NOT NULL
);


ALTER TABLE public.workspace_tickets_categories OWNER TO postgres;

--
-- Name: workspace_tickets_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_tickets_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_tickets_categories_id_seq OWNER TO postgres;

--
-- Name: workspace_tickets_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_tickets_categories_id_seq OWNED BY public.workspace_tickets_categories.id;


--
-- Name: workspace_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_tickets_id_seq OWNER TO postgres;

--
-- Name: workspace_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_tickets_id_seq OWNED BY public.workspace_tickets.id;


--
-- Name: workspace_tickets_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_tickets_statuses (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    ticket_type character varying(50) NOT NULL,
    ticket_status character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_tickets_statuses OWNER TO postgres;

--
-- Name: workspace_tickets_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_tickets_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_tickets_statuses_id_seq OWNER TO postgres;

--
-- Name: workspace_tickets_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_tickets_statuses_id_seq OWNED BY public.workspace_tickets_statuses.id;


--
-- Name: workspace_timeline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_timeline (
    id bigint NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    timeline_uuid character varying(40) NOT NULL,
    object_type character varying(50) NOT NULL,
    object_uuid character varying(100) NOT NULL,
    by_user_id bigint NOT NULL,
    by_user_name character varying(50) NOT NULL,
    changed_field text NOT NULL,
    timestamp_epoch bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    event_type character varying(150) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_timeline OWNER TO postgres;

--
-- Name: workspace_timeline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_timeline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_timeline_id_seq OWNER TO postgres;

--
-- Name: workspace_timeline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_timeline_id_seq OWNED BY public.workspace_timeline.id;


--
-- Name: workspace_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_users (
    id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id smallint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    org_id bigint NOT NULL,
    company_uuid character varying(40) DEFAULT ''::character varying NOT NULL,
    responsibility character varying(250) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.workspace_users OWNER TO postgres;

--
-- Name: workspace_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_users_id_seq OWNER TO postgres;

--
-- Name: workspace_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_users_id_seq OWNED BY public.workspace_users.id;


--
-- Name: workspace_variable_monitor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_variable_monitor (
    uuid character varying(40) NOT NULL,
    org_id bigint NOT NULL,
    workspace_id bigint NOT NULL,
    device_id bigint NOT NULL,
    variable_uuid character varying(40) NOT NULL,
    variable_id bigint NOT NULL,
    action_uuid character varying(40) NOT NULL,
    monitor_time_minute integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspace_variable_monitor OWNER TO postgres;

--
-- Name: workspace_variables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace_variables (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    name_label character varying(255) NOT NULL,
    identifier character varying(255) NOT NULL,
    type character varying(15) NOT NULL,
    datatype character varying(15) NOT NULL,
    unit character varying(20),
    description character varying(200),
    pre_save_script character varying(250),
    validation_script character varying(250),
    ttl_seconds bigint DEFAULT 0,
    workspace_id bigint NOT NULL,
    site_id bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    org_id bigint NOT NULL,
    device_id bigint NOT NULL,
    decimal_precision smallint DEFAULT 5 NOT NULL,
    widget_color character varying(15) DEFAULT '#4356C7'::character varying NOT NULL,
    device_variable_identifier character varying(255) NOT NULL,
    is_standalone boolean DEFAULT false NOT NULL,
    derivation_script character varying(250),
    is_monitor boolean DEFAULT false NOT NULL
);


ALTER TABLE public.workspace_variables OWNER TO postgres;

--
-- Name: COLUMN workspace_variables.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workspace_variables.type IS 'Raw or Derived';


--
-- Name: workspace_variables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspace_variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspace_variables_id_seq OWNER TO postgres;

--
-- Name: workspace_variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspace_variables_id_seq OWNED BY public.workspace_variables.id;


--
-- Name: workspace_workorders_count_per_status_by_site; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.workspace_workorders_count_per_status_by_site AS
 SELECT ws.workspace_id,
    ws.org_id,
    ws.name AS site_name,
    ws.uuid AS site_uuid,
    wt.ticket_status,
    count(wt.id) AS ticket_count
   FROM (((public.workspace_sites ws
     JOIN public.workspace_locations wl ON (((ws.uuid)::text = (wl.sites_uuid)::text)))
     JOIN public.workspace_assets wa ON (((wl.uuid)::text = (wa.location_uuid)::text)))
     JOIN public.workspace_tickets wt ON (((wa.uuid)::text = (wt.asset_uuid)::text)))
  GROUP BY ws.workspace_id, ws.org_id, ws.name, ws.uuid, wt.ticket_status;


ALTER VIEW public.workspace_workorders_count_per_status_by_site OWNER TO postgres;

--
-- Name: workspaces; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspaces (
    id bigint NOT NULL,
    uuid character varying(40) NOT NULL,
    name character varying(50) NOT NULL,
    org_id bigint NOT NULL,
    time_zone character varying(25) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    active boolean DEFAULT true NOT NULL,
    description character varying(250) NOT NULL,
    allow_manage_users boolean DEFAULT false NOT NULL,
    enable_cmms boolean DEFAULT false NOT NULL,
    currency_code character varying(10) DEFAULT 'USD'::character varying NOT NULL,
    is_startup boolean DEFAULT false NOT NULL,
    ai_routing_enabled boolean DEFAULT false NOT NULL,
    enable_iot boolean DEFAULT true NOT NULL,
    enable_csp boolean DEFAULT false NOT NULL,
    workspace_code character varying(40) NOT NULL
);


ALTER TABLE public.workspaces OWNER TO postgres;

--
-- Name: workspaces_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspaces_id_seq OWNER TO postgres;

--
-- Name: workspaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspaces_id_seq OWNED BY public.workspaces.id;


--
-- Name: workspaces_registry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspaces_registry (
    id bigint NOT NULL,
    org_id bigint NOT NULL,
    org_uuid character varying(40) NOT NULL,
    workspace_id bigint NOT NULL,
    workspace_uuid character varying(40) NOT NULL,
    active boolean NOT NULL,
    time_zone character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workspaces_registry OWNER TO postgres;

--
-- Name: workspaces_registry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspaces_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workspaces_registry_id_seq OWNER TO postgres;

--
-- Name: workspaces_registry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspaces_registry_id_seq OWNED BY public.workspaces_registry.id;


--
-- Name: organisation_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users ALTER COLUMN id SET DEFAULT nextval('public.organisation_users_id_seq'::regclass);


--
-- Name: organisations org_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations ALTER COLUMN org_id SET DEFAULT nextval('public.organisations_org_id_seq'::regclass);


--
-- Name: tickets_registry id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets_registry ALTER COLUMN id SET DEFAULT nextval('public.tickets_registry_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workspace_amenities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_amenities ALTER COLUMN id SET DEFAULT nextval('public.workspace_amenities_id_seq'::regclass);


--
-- Name: workspace_assets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets ALTER COLUMN id SET DEFAULT nextval('public.workspace_assets_id_seq'::regclass);


--
-- Name: workspace_assets_criticalities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets_criticalities ALTER COLUMN id SET DEFAULT nextval('public.workspace_assets_criticalities_id_seq'::regclass);


--
-- Name: workspace_assets_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets_types ALTER COLUMN id SET DEFAULT nextval('public.workspace_assets_types_id_seq'::regclass);


--
-- Name: workspace_checklist_item_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_item_categories ALTER COLUMN id SET DEFAULT nextval('public.workspace_checklist_item_categories_id_seq'::regclass);


--
-- Name: workspace_checklist_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_items ALTER COLUMN id SET DEFAULT nextval('public.workspace_checklist_items_id_seq'::regclass);


--
-- Name: workspace_checklist_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_records ALTER COLUMN id SET DEFAULT nextval('public.workspace_checklist_records_id_seq'::regclass);


--
-- Name: workspace_checklists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklists ALTER COLUMN id SET DEFAULT nextval('public.workspace_checklists_id_seq'::regclass);


--
-- Name: workspace_contract_assets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_contract_assets ALTER COLUMN id SET DEFAULT nextval('public.workspace_contract_assets_id_seq'::regclass);


--
-- Name: workspace_csp_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_csp_settings ALTER COLUMN id SET DEFAULT nextval('public.workspace_csp_settings_id_seq'::regclass);


--
-- Name: workspace_dashboards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboards ALTER COLUMN id SET DEFAULT nextval('public.workspace_dashboards_id_seq'::regclass);


--
-- Name: workspace_devices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_devices ALTER COLUMN id SET DEFAULT nextval('public.workspace_devices_id_seq'::regclass);


--
-- Name: workspace_faqs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_faqs ALTER COLUMN id SET DEFAULT nextval('public.workspace_faqs_id_seq'::regclass);


--
-- Name: workspace_feedback_forms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_forms ALTER COLUMN id SET DEFAULT nextval('public.workspace_feedback_forms_id_seq'::regclass);


--
-- Name: workspace_feedback_question_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_question_categories ALTER COLUMN id SET DEFAULT nextval('public.workspace_feedback_categories_id_seq'::regclass);


--
-- Name: workspace_feedback_questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_questions ALTER COLUMN id SET DEFAULT nextval('public.workspace_feedback_questions_id_seq'::regclass);


--
-- Name: workspace_feedback_responses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_responses ALTER COLUMN id SET DEFAULT nextval('public.workspace_feedback_responses_id_seq'::regclass);


--
-- Name: workspace_feedback_sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_sessions ALTER COLUMN id SET DEFAULT nextval('public.workspace_feedback_sessions_id_seq'::regclass);


--
-- Name: workspace_files file_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_files ALTER COLUMN file_id SET DEFAULT nextval('public.workspace_files_file_id_seq'::regclass);


--
-- Name: workspace_general_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_general_info ALTER COLUMN id SET DEFAULT nextval('public.workspace_general_info_id_seq'::regclass);


--
-- Name: workspace_hotel_emergency id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_hotel_emergency ALTER COLUMN id SET DEFAULT nextval('public.workspace_hotel_emergency_id_seq'::regclass);


--
-- Name: workspace_images image_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_images ALTER COLUMN image_id SET DEFAULT nextval('public.workspace_images_image_id_seq'::regclass);


--
-- Name: workspace_ingress_credentials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_ingress_credentials ALTER COLUMN id SET DEFAULT nextval('public.workspace_ingress_credentials_id_seq'::regclass);


--
-- Name: workspace_locations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_locations ALTER COLUMN id SET DEFAULT nextval('public.workspace_locations_id_seq'::regclass);


--
-- Name: workspace_nearby_attraction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_nearby_attraction ALTER COLUMN id SET DEFAULT nextval('public.workspace_attraction_id_seq'::regclass);


--
-- Name: workspace_offers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_offers ALTER COLUMN id SET DEFAULT nextval('public.workspace_offers_id_seq'::regclass);


--
-- Name: workspace_restaurants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_restaurants ALTER COLUMN id SET DEFAULT nextval('public.workspace_restaurants_id_seq'::regclass);


--
-- Name: workspace_service_contracts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_service_contracts ALTER COLUMN id SET DEFAULT nextval('public.workspace_service_contracts_id_seq'::regclass);


--
-- Name: workspace_team_members id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_team_members ALTER COLUMN id SET DEFAULT nextval('public.workspace_team_members_id_seq'::regclass);


--
-- Name: workspace_teams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_teams ALTER COLUMN id SET DEFAULT nextval('public.workspace_teams_id_seq'::regclass);


--
-- Name: workspace_tickets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets ALTER COLUMN id SET DEFAULT nextval('public.workspace_tickets_id_seq'::regclass);


--
-- Name: workspace_tickets_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets_categories ALTER COLUMN id SET DEFAULT nextval('public.workspace_tickets_categories_id_seq'::regclass);


--
-- Name: workspace_tickets_statuses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets_statuses ALTER COLUMN id SET DEFAULT nextval('public.workspace_tickets_statuses_id_seq'::regclass);


--
-- Name: workspace_timeline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_timeline ALTER COLUMN id SET DEFAULT nextval('public.workspace_timeline_id_seq'::regclass);


--
-- Name: workspace_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_users ALTER COLUMN id SET DEFAULT nextval('public.workspace_users_id_seq'::regclass);


--
-- Name: workspace_variables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variables ALTER COLUMN id SET DEFAULT nextval('public.workspace_variables_id_seq'::regclass);


--
-- Name: workspaces id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces ALTER COLUMN id SET DEFAULT nextval('public.workspaces_id_seq'::regclass);


--
-- Name: workspaces_registry id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces_registry ALTER COLUMN id SET DEFAULT nextval('public.workspaces_registry_id_seq'::regclass);


--
-- Name: users email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT email UNIQUE (email);


--
-- Name: users gip_uid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT gip_uid UNIQUE (gip_uid);


--
-- Name: inventory_registry inventory_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_registry
    ADD CONSTRAINT inventory_registry_pkey PRIMARY KEY (uuid);


--
-- Name: organisation_users organisation_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users
    ADD CONSTRAINT organisation_users_pkey PRIMARY KEY (id);


--
-- Name: organisations organisations_favicon_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT organisations_favicon_uuid_key UNIQUE (favicon_uuid);


--
-- Name: organisations organisations_logo_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT organisations_logo_uuid_key UNIQUE (logo_uuid);


--
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (org_id);


--
-- Name: workspace_users project_users_project_id_user_id_uindex; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_users
    ADD CONSTRAINT project_users_project_id_user_id_uindex UNIQUE (workspace_id, user_id);


--
-- Name: reports_registry reports_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports_registry
    ADD CONSTRAINT reports_registry_pkey PRIMARY KEY (uuid);


--
-- Name: reports_registry reports_registry_report_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports_registry
    ADD CONSTRAINT reports_registry_report_uuid_key UNIQUE (report_uuid);


--
-- Name: rooms_security rooms_security_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms_security
    ADD CONSTRAINT rooms_security_pkey PRIMARY KEY (uuid);


--
-- Name: scheduler_registry scheduler_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduler_registry
    ADD CONSTRAINT scheduler_registry_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_ingress_credentials secret_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_ingress_credentials
    ADD CONSTRAINT secret_key UNIQUE (secret_key);


--
-- Name: organisations subdomain; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT subdomain UNIQUE (subdomain);


--
-- Name: organisation_users tenant_users_id_tenant_id_user_id_uindex; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users
    ADD CONSTRAINT tenant_users_id_tenant_id_user_id_uindex UNIQUE (org_id, user_id);


--
-- Name: tickets_registry tickets_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets_registry
    ADD CONSTRAINT tickets_registry_pkey PRIMARY KEY (id);


--
-- Name: workspace_checklist_item_categories unique_category_name_per_workspace; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_item_categories
    ADD CONSTRAINT unique_category_name_per_workspace UNIQUE (workspace_id, category_name);


--
-- Name: workspace_checklists unique_name_per_workspace; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklists
    ADD CONSTRAINT unique_name_per_workspace UNIQUE (workspace_id, name);


--
-- Name: workspace_feedback_forms unique_org_workspace_feedback_form; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_forms
    ADD CONSTRAINT unique_org_workspace_feedback_form UNIQUE (org_id, workspace_id);


--
-- Name: rooms_security unique_room_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms_security
    ADD CONSTRAINT unique_room_code UNIQUE (room_code);


--
-- Name: workspaces unique_workspace_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT unique_workspace_code UNIQUE (workspace_code);


--
-- Name: workspace_inventory uq_workspace_ean; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_inventory
    ADD CONSTRAINT uq_workspace_ean UNIQUE (workspace_id, ean_number);


--
-- Name: workspace_inventory uq_workspace_isbn; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_inventory
    ADD CONSTRAINT uq_workspace_isbn UNIQUE (workspace_id, isbn_number);


--
-- Name: workspace_inventory uq_workspace_mpn; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_inventory
    ADD CONSTRAINT uq_workspace_mpn UNIQUE (workspace_id, mpn_number);


--
-- Name: workspace_parts_received uq_workspace_po_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_parts_received
    ADD CONSTRAINT uq_workspace_po_no UNIQUE (workspace_id, purchase_order_number);


--
-- Name: workspace_parts_received uq_workspace_recv_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_parts_received
    ADD CONSTRAINT uq_workspace_recv_no UNIQUE (workspace_id, purchase_received_number);


--
-- Name: workspace_inventory uq_workspace_sku; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_inventory
    ADD CONSTRAINT uq_workspace_sku UNIQUE (workspace_id, sku);


--
-- Name: workspace_inventory uq_workspace_upc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_inventory
    ADD CONSTRAINT uq_workspace_upc UNIQUE (workspace_id, upc_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workspace_dashboard_widgets uuid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboard_widgets
    ADD CONSTRAINT uuid PRIMARY KEY (id);


--
-- Name: workspace_variables uuid10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variables
    ADD CONSTRAINT uuid10 UNIQUE (uuid);


--
-- Name: organisations uuid2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT uuid2 UNIQUE (uuid);


--
-- Name: workspaces uuid3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT uuid3 UNIQUE (uuid);


--
-- Name: workspace_dashboards uuid4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboards
    ADD CONSTRAINT uuid4 UNIQUE (uuid);


--
-- Name: workspace_ingress_credentials uuid5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_ingress_credentials
    ADD CONSTRAINT uuid5 UNIQUE (uuid);


--
-- Name: workspace_sites uuid6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_sites
    ADD CONSTRAINT uuid6 PRIMARY KEY (uuid);


--
-- Name: workspace_devices uuid7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_devices
    ADD CONSTRAINT uuid7 UNIQUE (uuid);


--
-- Name: users uuid8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uuid8 UNIQUE (uuid);


--
-- Name: organisation_users uuid9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users
    ADD CONSTRAINT uuid9 UNIQUE (uuid);


--
-- Name: workspace_variables variables_id_variable_id_uindex; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variables
    ADD CONSTRAINT variables_id_variable_id_uindex UNIQUE (id, identifier);


--
-- Name: workspace_action_schedule workspace_action_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_action_schedule
    ADD CONSTRAINT workspace_action_schedule_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_actions workspace_actions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_actions
    ADD CONSTRAINT workspace_actions_pk PRIMARY KEY (uuid);


--
-- Name: workspace_alerts workspace_alerts_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_alerts
    ADD CONSTRAINT workspace_alerts_pk PRIMARY KEY (uuid);


--
-- Name: workspace_amenities workspace_amenities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_amenities
    ADD CONSTRAINT workspace_amenities_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_amenities workspace_amenities_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_amenities
    ADD CONSTRAINT workspace_amenities_uuid_key UNIQUE (uuid);


--
-- Name: workspace_assets workspace_asset_id_unique_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets
    ADD CONSTRAINT workspace_asset_id_unique_key UNIQUE (workspace_id, asset_id);


--
-- Name: workspace_assets workspace_asset_tag_unique_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets
    ADD CONSTRAINT workspace_asset_tag_unique_key UNIQUE (workspace_id, asset_tag);


--
-- Name: workspace_assets_criticalities workspace_assets_criticalities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets_criticalities
    ADD CONSTRAINT workspace_assets_criticalities_pkey PRIMARY KEY (id);


--
-- Name: workspace_assets_criticalities workspace_assets_criticalities_unique_name_workspace_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets_criticalities
    ADD CONSTRAINT workspace_assets_criticalities_unique_name_workspace_id UNIQUE (workspace_id, criticality_name);


--
-- Name: workspace_assets workspace_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets
    ADD CONSTRAINT workspace_assets_pkey PRIMARY KEY (id);


--
-- Name: workspace_assets_types workspace_assets_types_asset_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets_types
    ADD CONSTRAINT workspace_assets_types_asset_type_key UNIQUE (workspace_id, asset_type);


--
-- Name: workspace_assets_types workspace_assets_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_assets_types
    ADD CONSTRAINT workspace_assets_types_pkey PRIMARY KEY (id);


--
-- Name: workspace_nearby_attraction workspace_attraction_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_nearby_attraction
    ADD CONSTRAINT workspace_attraction_uuid_key UNIQUE (uuid);


--
-- Name: workspace_cabs workspace_cabs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_cabs
    ADD CONSTRAINT workspace_cabs_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_checklist_item_categories workspace_checklist_item_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_item_categories
    ADD CONSTRAINT workspace_checklist_item_categories_pkey PRIMARY KEY (id);


--
-- Name: workspace_checklist_item_categories workspace_checklist_item_categories_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_item_categories
    ADD CONSTRAINT workspace_checklist_item_categories_uuid_key UNIQUE (uuid);


--
-- Name: workspace_checklist_items workspace_checklist_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_items
    ADD CONSTRAINT workspace_checklist_items_pkey PRIMARY KEY (id);


--
-- Name: workspace_checklist_items workspace_checklist_items_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_items
    ADD CONSTRAINT workspace_checklist_items_uuid_key UNIQUE (uuid);


--
-- Name: workspace_checklist_records workspace_checklist_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_records
    ADD CONSTRAINT workspace_checklist_records_pkey PRIMARY KEY (id);


--
-- Name: workspace_checklist_records workspace_checklist_records_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklist_records
    ADD CONSTRAINT workspace_checklist_records_uuid_key UNIQUE (uuid);


--
-- Name: workspace_checklists workspace_checklists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklists
    ADD CONSTRAINT workspace_checklists_pkey PRIMARY KEY (id);


--
-- Name: workspace_checklists workspace_checklists_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_checklists
    ADD CONSTRAINT workspace_checklists_uuid_key UNIQUE (uuid);


--
-- Name: workspace_timeline workspace_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_timeline
    ADD CONSTRAINT workspace_comments_pkey PRIMARY KEY (id);


--
-- Name: workspace_companies workspace_companies_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_companies
    ADD CONSTRAINT workspace_companies_name UNIQUE (company_name, workspace_id);


--
-- Name: workspace_companies workspace_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_companies
    ADD CONSTRAINT workspace_companies_pkey PRIMARY KEY (id);


--
-- Name: workspace_contract_assets workspace_contract_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_contract_assets
    ADD CONSTRAINT workspace_contract_assets_pkey PRIMARY KEY (id);


--
-- Name: workspace_csp_settings workspace_csp_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_csp_settings
    ADD CONSTRAINT workspace_csp_settings_pkey PRIMARY KEY (id);


--
-- Name: workspace_csp_settings workspace_csp_settings_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_csp_settings
    ADD CONSTRAINT workspace_csp_settings_uuid_key UNIQUE (uuid);


--
-- Name: workspace_csp_settings workspace_csp_settings_workspace_id_setting_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_csp_settings
    ADD CONSTRAINT workspace_csp_settings_workspace_id_setting_key_key UNIQUE (workspace_id, setting_key);


--
-- Name: workspace_dashboards workspace_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboards
    ADD CONSTRAINT workspace_dashboards_pkey PRIMARY KEY (id);


--
-- Name: workspace_devices workspace_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_devices
    ADD CONSTRAINT workspace_devices_pkey PRIMARY KEY (id);


--
-- Name: workspace_energy_bills workspace_energy_bills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_energy_bills
    ADD CONSTRAINT workspace_energy_bills_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_faqs workspace_faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_faqs
    ADD CONSTRAINT workspace_faqs_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_faqs workspace_faqs_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_faqs
    ADD CONSTRAINT workspace_faqs_uuid_key UNIQUE (uuid);


--
-- Name: workspace_feedback_question_categories workspace_feedback_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_question_categories
    ADD CONSTRAINT workspace_feedback_categories_pkey PRIMARY KEY (id);


--
-- Name: workspace_feedback_question_categories workspace_feedback_categories_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_question_categories
    ADD CONSTRAINT workspace_feedback_categories_uuid_key UNIQUE (uuid);


--
-- Name: workspace_feedback_forms workspace_feedback_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_forms
    ADD CONSTRAINT workspace_feedback_forms_pkey PRIMARY KEY (id);


--
-- Name: workspace_feedback_forms workspace_feedback_forms_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_forms
    ADD CONSTRAINT workspace_feedback_forms_uuid_key UNIQUE (uuid);


--
-- Name: workspace_feedback_questions workspace_feedback_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_questions
    ADD CONSTRAINT workspace_feedback_questions_pkey PRIMARY KEY (id);


--
-- Name: workspace_feedback_responses workspace_feedback_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_responses
    ADD CONSTRAINT workspace_feedback_responses_pkey PRIMARY KEY (id);


--
-- Name: workspace_feedback_responses workspace_feedback_responses_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_responses
    ADD CONSTRAINT workspace_feedback_responses_uuid_key UNIQUE (uuid);


--
-- Name: workspace_feedback_sessions workspace_feedback_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_sessions
    ADD CONSTRAINT workspace_feedback_sessions_pkey PRIMARY KEY (id);


--
-- Name: workspace_feedback_sessions workspace_feedback_sessions_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_feedback_sessions
    ADD CONSTRAINT workspace_feedback_sessions_uuid_key UNIQUE (uuid);


--
-- Name: workspace_files workspace_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_files
    ADD CONSTRAINT workspace_files_pkey PRIMARY KEY (file_id);


--
-- Name: workspace_food_categories workspace_food_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_food_categories
    ADD CONSTRAINT workspace_food_categories_name_key UNIQUE (workspace_id, category_name);


--
-- Name: workspace_food_categories workspace_food_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_food_categories
    ADD CONSTRAINT workspace_food_categories_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_food_dishes workspace_food_dishes_dish_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_food_dishes
    ADD CONSTRAINT workspace_food_dishes_dish_code_key UNIQUE (workspace_id, dish_code);


--
-- Name: workspace_food_dishes workspace_food_dishes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_food_dishes
    ADD CONSTRAINT workspace_food_dishes_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_food_order_items workspace_food_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_food_order_items
    ADD CONSTRAINT workspace_food_order_items_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_food_orders workspace_food_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_food_orders
    ADD CONSTRAINT workspace_food_orders_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_general_info workspace_general_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_general_info
    ADD CONSTRAINT workspace_general_info_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_general_info workspace_general_info_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_general_info
    ADD CONSTRAINT workspace_general_info_uuid_key UNIQUE (uuid);


--
-- Name: workspace_hotel_emergency workspace_hotel_emergency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_hotel_emergency
    ADD CONSTRAINT workspace_hotel_emergency_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_hotel_emergency workspace_hotel_emergency_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_hotel_emergency
    ADD CONSTRAINT workspace_hotel_emergency_uuid_key UNIQUE (uuid);


--
-- Name: workspace_images workspace_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_images
    ADD CONSTRAINT workspace_images_pkey PRIMARY KEY (image_id);


--
-- Name: workspace_ingress_credentials workspace_ingress_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_ingress_credentials
    ADD CONSTRAINT workspace_ingress_credentials_pkey PRIMARY KEY (id);


--
-- Name: workspace_inventory workspace_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_inventory
    ADD CONSTRAINT workspace_inventory_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_locations workspace_locations_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_locations
    ADD CONSTRAINT workspace_locations_name_pkey UNIQUE (name, workspace_id);


--
-- Name: workspace_locations workspace_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_locations
    ADD CONSTRAINT workspace_locations_pkey PRIMARY KEY (id);


--
-- Name: workspace_nearby_attraction workspace_nearby_attraction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_nearby_attraction
    ADD CONSTRAINT workspace_nearby_attraction_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_offers workspace_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_offers
    ADD CONSTRAINT workspace_offers_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_offers workspace_offers_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_offers
    ADD CONSTRAINT workspace_offers_uuid_key UNIQUE (uuid);


--
-- Name: workspace_parts_received workspace_parts_received_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_parts_received
    ADD CONSTRAINT workspace_parts_received_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_parts_request workspace_parts_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_parts_request
    ADD CONSTRAINT workspace_parts_request_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_reports workspace_reports_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_reports
    ADD CONSTRAINT workspace_reports_pk PRIMARY KEY (uuid);


--
-- Name: workspace_restaurants workspace_restaurants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_restaurants
    ADD CONSTRAINT workspace_restaurants_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_restaurants workspace_restaurants_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_restaurants
    ADD CONSTRAINT workspace_restaurants_uuid_key UNIQUE (uuid);


--
-- Name: workspace_room_item_categories workspace_room_item_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_room_item_categories
    ADD CONSTRAINT workspace_room_item_categories_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_room_items workspace_room_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_room_items
    ADD CONSTRAINT workspace_room_items_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_room_item_categories workspace_room_supplies_categories_unique_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_room_item_categories
    ADD CONSTRAINT workspace_room_supplies_categories_unique_name UNIQUE (workspace_id, category_name);


--
-- Name: workspace_room_items workspace_room_supplies_items_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_room_items
    ADD CONSTRAINT workspace_room_supplies_items_code_key UNIQUE (workspace_id, item_code);


--
-- Name: workspace_room_supply_request_items workspace_room_supply_request_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_room_supply_request_items
    ADD CONSTRAINT workspace_room_supply_request_items_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_room_supply_requests workspace_room_supply_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_room_supply_requests
    ADD CONSTRAINT workspace_room_supply_requests_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_rules workspace_rules_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_rules
    ADD CONSTRAINT workspace_rules_pk PRIMARY KEY (uuid);


--
-- Name: workspace_service_contracts workspace_service_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_service_contracts
    ADD CONSTRAINT workspace_service_contracts_pkey PRIMARY KEY (id);


--
-- Name: workspace_service_requests workspace_service_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_service_requests
    ADD CONSTRAINT workspace_service_requests_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_team_members workspace_team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_team_members
    ADD CONSTRAINT workspace_team_members_pkey PRIMARY KEY (id);


--
-- Name: workspace_teams workspace_team_name_unique_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_teams
    ADD CONSTRAINT workspace_team_name_unique_key UNIQUE (workspace_id, team_name);


--
-- Name: workspace_teams workspace_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_teams
    ADD CONSTRAINT workspace_teams_pkey PRIMARY KEY (id);


--
-- Name: workspace_tickets workspace_ticket_id_unique_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets
    ADD CONSTRAINT workspace_ticket_id_unique_key UNIQUE (ticket_id, workspace_id);


--
-- Name: workspace_tickets_categories workspace_tickets_categories_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets_categories
    ADD CONSTRAINT workspace_tickets_categories_categories_name_key UNIQUE (categories_name, workspace_id);


--
-- Name: workspace_tickets_categories workspace_tickets_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets_categories
    ADD CONSTRAINT workspace_tickets_categories_pkey PRIMARY KEY (id);


--
-- Name: workspace_tickets workspace_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets
    ADD CONSTRAINT workspace_tickets_pkey PRIMARY KEY (id);


--
-- Name: workspace_tickets_statuses workspace_tickets_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets_statuses
    ADD CONSTRAINT workspace_tickets_statuses_pkey PRIMARY KEY (id);


--
-- Name: workspace_tickets_statuses workspace_tickets_statuses_ticket_status_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_tickets_statuses
    ADD CONSTRAINT workspace_tickets_statuses_ticket_status_key UNIQUE (ticket_status, workspace_id);


--
-- Name: workspace_users workspace_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_users
    ADD CONSTRAINT workspace_users_pkey PRIMARY KEY (id);


--
-- Name: workspace_variable_monitor workspace_variable_monitor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variable_monitor
    ADD CONSTRAINT workspace_variable_monitor_pkey PRIMARY KEY (uuid);


--
-- Name: workspace_variable_monitor workspace_variable_monitor_variable_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variable_monitor
    ADD CONSTRAINT workspace_variable_monitor_variable_uuid_key UNIQUE (variable_uuid);


--
-- Name: workspace_variables workspace_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variables
    ADD CONSTRAINT workspace_variables_pkey PRIMARY KEY (id);


--
-- Name: workspaces workspaces_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);


--
-- Name: workspaces_registry workspaces_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces_registry
    ADD CONSTRAINT workspaces_registry_pkey PRIMARY KEY (id);


--
-- Name: workspace_devices_id_identifier_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX workspace_devices_id_identifier_uindex ON public.workspace_devices USING btree (workspace_id, identifier);


--
-- Name: workspace_variables_device_id_device_identifier_workspace_id_ui; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX workspace_variables_device_id_device_identifier_workspace_id_ui ON public.workspace_variables USING btree (device_id, device_variable_identifier, workspace_id);


--
-- Name: workspace_variables_workspace_id_lower(variable_id)_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "workspace_variables_workspace_id_lower(variable_id)_uindex" ON public.workspace_variables USING btree (workspace_id, lower((identifier)::text));


--
-- Name: organisation_users update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.organisation_users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: organisations update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.organisations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_alerts update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_alerts FOR EACH ROW EXECUTE FUNCTION public.update_epoch_updated_at_column();


--
-- Name: workspace_dashboard_widgets update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_dashboard_widgets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_dashboards update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_dashboards FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_devices update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_devices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_ingress_credentials update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_ingress_credentials FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_rules update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_rules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_sites update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_sites FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_users update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_variables update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspace_variables FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspaces update_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON public.workspaces FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workspace_dashboard_widgets dashboard_widgets_dashboards_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboard_widgets
    ADD CONSTRAINT dashboard_widgets_dashboards_id_fk FOREIGN KEY (dashboard_id) REFERENCES public.workspace_dashboards(id);


--
-- Name: workspace_dashboard_widgets dashboard_widgets_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboard_widgets
    ADD CONSTRAINT dashboard_widgets_organisations_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_dashboard_widgets dashboard_widgets_workspaces_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboard_widgets
    ADD CONSTRAINT dashboard_widgets_workspaces_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_dashboards dashboards_org_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboards
    ADD CONSTRAINT dashboards_org_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_dashboards dashboards_workspace_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_dashboards
    ADD CONSTRAINT dashboards_workspace_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_devices devices_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_devices
    ADD CONSTRAINT devices_organisations_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_devices devices_workspace_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_devices
    ADD CONSTRAINT devices_workspace_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_ingress_credentials ingress_credentials_org_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_ingress_credentials
    ADD CONSTRAINT ingress_credentials_org_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_ingress_credentials ingress_credentials_workspace_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_ingress_credentials
    ADD CONSTRAINT ingress_credentials_workspace_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_sites locations_projects_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_sites
    ADD CONSTRAINT locations_projects_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_users project_users_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_users
    ADD CONSTRAINT project_users_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: workspace_users project_users_workspace_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_users
    ADD CONSTRAINT project_users_workspace_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspaces projects_org_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT projects_org_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_sites site_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_sites
    ADD CONSTRAINT site_organisations_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: organisation_users tenant_users_tenants_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users
    ADD CONSTRAINT tenant_users_tenants_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: organisation_users tenant_users_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_users
    ADD CONSTRAINT tenant_users_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: workspace_variables variables_devices_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variables
    ADD CONSTRAINT variables_devices_id_fk FOREIGN KEY (device_id) REFERENCES public.workspace_devices(id);


--
-- Name: workspace_variables variables_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variables
    ADD CONSTRAINT variables_organisations_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_variables variables_workspaces_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_variables
    ADD CONSTRAINT variables_workspaces_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_actions workspace_actions_organisations_org_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_actions
    ADD CONSTRAINT workspace_actions_organisations_org_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_actions workspace_actions_workspaces_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_actions
    ADD CONSTRAINT workspace_actions_workspaces_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_alerts workspace_alerts_organisations_org_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_alerts
    ADD CONSTRAINT workspace_alerts_organisations_org_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_alerts workspace_alerts_workspaces_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_alerts
    ADD CONSTRAINT workspace_alerts_workspaces_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_reports workspace_reports_organisations_org_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_reports
    ADD CONSTRAINT workspace_reports_organisations_org_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_reports workspace_reports_workspaces_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_reports
    ADD CONSTRAINT workspace_reports_workspaces_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_rules workspace_rules_organisations_org_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_rules
    ADD CONSTRAINT workspace_rules_organisations_org_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_rules workspace_rules_workspaces_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_rules
    ADD CONSTRAINT workspace_rules_workspaces_id_fk FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_users workspace_users_organisations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace_users
    ADD CONSTRAINT workspace_users_organisations_id_fk FOREIGN KEY (org_id) REFERENCES public.organisations(org_id);


--
-- Name: workspace_action_schedule organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_action_schedule USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_actions organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_actions USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_alerts organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_alerts USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_amenities organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_amenities USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_assets organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_assets USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_assets_criticalities organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_assets_criticalities USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_assets_types organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_assets_types USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_cabs organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_cabs USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_checklist_item_categories organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_checklist_item_categories USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_checklist_items organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_checklist_items USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_checklist_records organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_checklist_records USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_checklists organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_checklists USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_companies organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_companies USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_contract_assets organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_contract_assets USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_csp_settings organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_csp_settings USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_dashboard_widgets organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_dashboard_widgets USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_dashboards organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_dashboards USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_devices organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_devices USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_energy_bills organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_energy_bills USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_faqs organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_faqs USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_feedback_forms organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_feedback_forms USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_feedback_question_categories organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_feedback_question_categories USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_feedback_questions organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_feedback_questions USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_feedback_responses organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_feedback_responses USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_feedback_sessions organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_feedback_sessions USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_files organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_files USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_food_categories organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_food_categories USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_food_dishes organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_food_dishes USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_food_order_items organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_food_order_items USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_food_orders organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_food_orders USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_general_info organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_general_info USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_images organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_images USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_ingress_credentials organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_ingress_credentials USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_inventory organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_inventory USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_locations organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_locations USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_nearby_attraction organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_nearby_attraction USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_parts_received organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_parts_received USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_parts_request organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_parts_request USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_reports organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_reports USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_restaurants organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_restaurants USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_room_item_categories organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_room_item_categories USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_room_items organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_room_items USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_room_supply_request_items organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_room_supply_request_items USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_room_supply_requests organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_room_supply_requests USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_rules organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_rules USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_service_contracts organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_service_contracts USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_service_requests organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_service_requests USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_sites organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_sites USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_team_members organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_team_members USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_teams organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_teams USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_tickets organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_tickets USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_tickets_categories organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_tickets_categories USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_tickets_statuses organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_tickets_statuses USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_timeline organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_timeline USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_variable_monitor organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_variable_monitor USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: workspace_variables organisation_and_workspace_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_and_workspace_isolation_policy ON public.workspace_variables USING (((org_id = (current_setting('app.org_id'::text))::bigint) AND (workspace_id = (current_setting('app.ws_id'::text))::bigint)));


--
-- Name: organisation_users organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.organisation_users USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: organisations organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.organisations USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_actions organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_actions USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_alerts organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_alerts USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_dashboard_widgets organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_dashboard_widgets USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_dashboards organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_dashboards USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_devices organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_devices USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_ingress_credentials organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_ingress_credentials USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_reports organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_reports USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_rules organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_rules USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_service_contracts organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_service_contracts USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_sites organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_sites USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_users organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_users USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_variable_monitor organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_variable_monitor USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspace_variables organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspace_variables USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: workspaces organisation_isolation_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY organisation_isolation_policy ON public.workspaces USING ((org_id = (current_setting('app.org_id'::text))::bigint));


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO appuser;


--
-- Name: FUNCTION update_epoch_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_epoch_updated_at_column() TO appuser;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO appuser;


--
-- Name: TABLE inventory_registry; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.inventory_registry TO appuser;


--
-- Name: TABLE organisation_users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organisation_users TO appuser;


--
-- Name: SEQUENCE organisation_users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.organisation_users_id_seq TO appuser;


--
-- Name: TABLE organisations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.organisations TO appuser;


--
-- Name: SEQUENCE organisations_org_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.organisations_org_id_seq TO appuser;


--
-- Name: TABLE reports_registry; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.reports_registry TO appuser;


--
-- Name: TABLE rooms_security; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.rooms_security TO appuser;


--
-- Name: TABLE scheduler_registry; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.scheduler_registry TO appuser;


--
-- Name: TABLE tickets_registry; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.tickets_registry TO appuser;


--
-- Name: SEQUENCE tickets_registry_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.tickets_registry_id_seq TO appuser;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO appuser;


--
-- Name: TABLE workspace_tickets; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_tickets TO appuser;


--
-- Name: TABLE user_ticket_counts; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.user_ticket_counts TO appuser;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.users_id_seq TO appuser;


--
-- Name: TABLE workspace_action_schedule; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_action_schedule TO appuser;


--
-- Name: TABLE workspace_actions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_actions TO appuser;


--
-- Name: TABLE workspace_alerts; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_alerts TO appuser;


--
-- Name: TABLE workspace_amenities; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_amenities TO appuser;


--
-- Name: SEQUENCE workspace_amenities_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_amenities_id_seq TO appuser;


--
-- Name: TABLE workspace_assets; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_assets TO appuser;


--
-- Name: TABLE workspace_assets_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_assets_types TO appuser;


--
-- Name: TABLE workspace_asset_type_summary; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_asset_type_summary TO appuser;


--
-- Name: TABLE workspace_asset_work_order_count; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_asset_work_order_count TO appuser;


--
-- Name: TABLE workspace_assets_criticalities; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_assets_criticalities TO appuser;


--
-- Name: SEQUENCE workspace_assets_criticalities_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_assets_criticalities_id_seq TO appuser;


--
-- Name: SEQUENCE workspace_assets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_assets_id_seq TO appuser;


--
-- Name: SEQUENCE workspace_assets_types_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_assets_types_id_seq TO appuser;


--
-- Name: TABLE workspace_nearby_attraction; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_nearby_attraction TO appuser;


--
-- Name: SEQUENCE workspace_attraction_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_attraction_id_seq TO appuser;


--
-- Name: TABLE workspace_cabs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_cabs TO appuser;


--
-- Name: TABLE workspace_checklist_item_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_checklist_item_categories TO appuser;


--
-- Name: SEQUENCE workspace_checklist_item_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_checklist_item_categories_id_seq TO appuser;


--
-- Name: TABLE workspace_checklist_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_checklist_items TO appuser;


--
-- Name: SEQUENCE workspace_checklist_items_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_checklist_items_id_seq TO appuser;


--
-- Name: TABLE workspace_checklist_records; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_checklist_records TO appuser;


--
-- Name: SEQUENCE workspace_checklist_records_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_checklist_records_id_seq TO appuser;


--
-- Name: TABLE workspace_checklists; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_checklists TO appuser;


--
-- Name: SEQUENCE workspace_checklists_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_checklists_id_seq TO appuser;


--
-- Name: SEQUENCE workspace_company_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_company_id_seq TO appuser;


--
-- Name: TABLE workspace_companies; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_companies TO appuser;


--
-- Name: TABLE workspace_contract_assets; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_contract_assets TO appuser;


--
-- Name: SEQUENCE workspace_contract_assets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_contract_assets_id_seq TO appuser;


--
-- Name: TABLE workspace_csp_settings; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_csp_settings TO appuser;


--
-- Name: SEQUENCE workspace_csp_settings_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_csp_settings_id_seq TO appuser;


--
-- Name: TABLE workspace_dashboard_widgets; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_dashboard_widgets TO appuser;


--
-- Name: SEQUENCE workspace_dashboard_widgets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_dashboard_widgets_id_seq TO appuser;


--
-- Name: TABLE workspace_dashboards; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_dashboards TO appuser;


--
-- Name: SEQUENCE workspace_dashboards_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_dashboards_id_seq TO appuser;


--
-- Name: TABLE workspace_devices; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_devices TO appuser;


--
-- Name: SEQUENCE workspace_devices_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_devices_id_seq TO appuser;


--
-- Name: TABLE workspace_energy_bills; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_energy_bills TO appuser;


--
-- Name: TABLE workspace_faqs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_faqs TO appuser;


--
-- Name: SEQUENCE workspace_faqs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_faqs_id_seq TO appuser;


--
-- Name: TABLE workspace_feedback_question_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_feedback_question_categories TO appuser;


--
-- Name: SEQUENCE workspace_feedback_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_feedback_categories_id_seq TO appuser;


--
-- Name: TABLE workspace_feedback_forms; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_feedback_forms TO appuser;


--
-- Name: SEQUENCE workspace_feedback_forms_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_feedback_forms_id_seq TO appuser;


--
-- Name: TABLE workspace_feedback_questions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_feedback_questions TO appuser;


--
-- Name: SEQUENCE workspace_feedback_questions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_feedback_questions_id_seq TO appuser;


--
-- Name: TABLE workspace_feedback_responses; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_feedback_responses TO appuser;


--
-- Name: SEQUENCE workspace_feedback_responses_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_feedback_responses_id_seq TO appuser;


--
-- Name: TABLE workspace_feedback_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_feedback_sessions TO appuser;


--
-- Name: SEQUENCE workspace_feedback_sessions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_feedback_sessions_id_seq TO appuser;


--
-- Name: TABLE workspace_files; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_files TO appuser;


--
-- Name: SEQUENCE workspace_files_file_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_files_file_id_seq TO appuser;


--
-- Name: TABLE workspace_food_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_food_categories TO appuser;


--
-- Name: TABLE workspace_food_dishes; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_food_dishes TO appuser;


--
-- Name: TABLE workspace_food_order_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_food_order_items TO appuser;


--
-- Name: TABLE workspace_food_orders; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_food_orders TO appuser;


--
-- Name: TABLE workspace_general_info; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_general_info TO appuser;


--
-- Name: SEQUENCE workspace_general_info_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_general_info_id_seq TO appuser;


--
-- Name: TABLE workspace_hotel_emergency; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_hotel_emergency TO appuser;


--
-- Name: SEQUENCE workspace_hotel_emergency_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_hotel_emergency_id_seq TO appuser;


--
-- Name: TABLE workspace_images; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_images TO appuser;


--
-- Name: SEQUENCE workspace_images_image_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_images_image_id_seq TO appuser;


--
-- Name: TABLE workspace_ingress_credentials; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_ingress_credentials TO appuser;


--
-- Name: SEQUENCE workspace_ingress_credentials_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_ingress_credentials_id_seq TO appuser;


--
-- Name: TABLE workspace_inventory; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_inventory TO appuser;


--
-- Name: TABLE workspace_locations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_locations TO appuser;


--
-- Name: SEQUENCE workspace_locations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_locations_id_seq TO appuser;


--
-- Name: TABLE workspace_offers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_offers TO appuser;


--
-- Name: SEQUENCE workspace_offers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_offers_id_seq TO appuser;


--
-- Name: TABLE workspace_parts_received; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_parts_received TO appuser;


--
-- Name: TABLE workspace_parts_request; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_parts_request TO appuser;


--
-- Name: TABLE workspace_reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_reports TO appuser;


--
-- Name: TABLE workspace_restaurants; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_restaurants TO appuser;


--
-- Name: SEQUENCE workspace_restaurants_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_restaurants_id_seq TO appuser;


--
-- Name: TABLE workspace_room_item_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_room_item_categories TO appuser;


--
-- Name: TABLE workspace_room_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_room_items TO appuser;


--
-- Name: TABLE workspace_room_supply_request_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_room_supply_request_items TO appuser;


--
-- Name: TABLE workspace_room_supply_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_room_supply_requests TO appuser;


--
-- Name: TABLE workspace_rules; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_rules TO appuser;


--
-- Name: TABLE workspace_service_contracts; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_service_contracts TO appuser;


--
-- Name: SEQUENCE workspace_service_contracts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_service_contracts_id_seq TO appuser;


--
-- Name: TABLE workspace_service_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_service_requests TO appuser;


--
-- Name: TABLE workspace_sites; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_sites TO appuser;


--
-- Name: TABLE workspace_team_members; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_team_members TO appuser;


--
-- Name: SEQUENCE workspace_team_members_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_team_members_id_seq TO appuser;


--
-- Name: TABLE workspace_teams; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_teams TO appuser;


--
-- Name: SEQUENCE workspace_teams_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_teams_id_seq TO appuser;


--
-- Name: TABLE workspace_ticket_summary_by_category; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_ticket_summary_by_category TO appuser;


--
-- Name: TABLE workspace_tickets_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_tickets_categories TO appuser;


--
-- Name: SEQUENCE workspace_tickets_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_tickets_categories_id_seq TO appuser;


--
-- Name: SEQUENCE workspace_tickets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_tickets_id_seq TO appuser;


--
-- Name: TABLE workspace_tickets_statuses; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_tickets_statuses TO appuser;


--
-- Name: SEQUENCE workspace_tickets_statuses_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_tickets_statuses_id_seq TO appuser;


--
-- Name: TABLE workspace_timeline; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_timeline TO appuser;


--
-- Name: SEQUENCE workspace_timeline_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_timeline_id_seq TO appuser;


--
-- Name: TABLE workspace_users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_users TO appuser;


--
-- Name: SEQUENCE workspace_users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_users_id_seq TO appuser;


--
-- Name: TABLE workspace_variable_monitor; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_variable_monitor TO appuser;


--
-- Name: TABLE workspace_variables; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_variables TO appuser;


--
-- Name: SEQUENCE workspace_variables_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspace_variables_id_seq TO appuser;


--
-- Name: TABLE workspace_workorders_count_per_status_by_site; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspace_workorders_count_per_status_by_site TO appuser;


--
-- Name: TABLE workspaces; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspaces TO appuser;


--
-- Name: SEQUENCE workspaces_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspaces_id_seq TO appuser;


--
-- Name: TABLE workspaces_registry; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.workspaces_registry TO appuser;


--
-- Name: SEQUENCE workspaces_registry_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.workspaces_registry_id_seq TO appuser;


--
-- PostgreSQL database dump complete
--

