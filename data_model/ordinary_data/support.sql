-- Table: signalo_od.support

-- DROP TABLE signalo_od.support;

CREATE TABLE signalo_od.support
(
    id uuid PRIMARY KEY default uuid_generate_v1(),
    address text,
    fk_support_type int,
    fk_owner uuid,
    fk_provider uuid,
    fk_support_base_type int,
    road_segment text,
    height numeric(8,3),
    height_free_under_signal numeric(8,3),
    date_install date,
    date_last_stability_check date,
    fk_status int,
    comment text,
    photo text,
    geometry geometry(Point,:SRID) NOT NULL,
    _inserted_date timestamp default now(),
    _inserted_user text,
    _last_modified_date timestamp default now(),
    _last_modified_user text,
    _edited boolean default false,
    CONSTRAINT fkey_vl_support_type FOREIGN KEY (fk_support_type) REFERENCES signalo_vl.support_type (id) MATCH FULL,
    CONSTRAINT fkey_od_owner FOREIGN KEY (fk_owner) REFERENCES signalo_od.owner (id) MATCH FULL,
    CONSTRAINT fkey_od_provider FOREIGN KEY (fk_provider) REFERENCES signalo_od.provider (id) MATCH FULL,
    CONSTRAINT fkey_vl_status FOREIGN KEY (fk_status) REFERENCES signalo_vl.status (id) MATCH FULL,
    CONSTRAINT fkey_vl_support_base_type FOREIGN KEY (fk_support_base_type) REFERENCES signalo_vl.support_base_type (id) MATCH FULL
);