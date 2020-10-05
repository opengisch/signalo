-- Table: siro_od.frame

-- DROP TABLE siro_od.frame;

CREATE TABLE siro_od.frame
(
    id uuid PRIMARY KEY default uuid_generate_v1(),
    fk_support uuid,
    rank int default 1, -- TODO: get default
    fk_frame_type int,
    fk_frame_fixing_type int,
    double_sided boolean default true,
    fk_status int,
    comment text,
    picture text,
    CONSTRAINT fkey_od_support FOREIGN KEY (fk_support) REFERENCES siro_od.support (id) MATCH SIMPLE,
    CONSTRAINT fkey_vl_frame_type FOREIGN KEY (fk_frame_type) REFERENCES siro_vl.frame_type (id) MATCH SIMPLE,
    CONSTRAINT fkey_vl_status FOREIGN KEY (fk_status) REFERENCES siro_vl.status (id) MATCH SIMPLE,
    CONSTRAINT fkey_vl_frame_fixing_type FOREIGN KEY (fk_frame_fixing_type) REFERENCES siro_vl.frame_fixing_type (id) MATCH SIMPLE,
    UNIQUE (fk_support, rank)
);
