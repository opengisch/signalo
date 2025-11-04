CREATE TABLE signalo_db.dms_document(
  id uuid DEFAULT uuid_generate_v1() NOT NULL,
  identification text NOT NULL,
  path text,
  type text
);
ALTER TABLE ONLY signalo_db.dms_document ADD CONSTRAINT dms_document_pkey PRIMARY KEY (id);


CREATE TABLE signalo_db.dms_rel_document(
  id uuid DEFAULT uuid_generate_v1() NOT NULL,
  fk_document uuid,
  object_class text,
  fk_object uuid
);

ALTER TABLE ONLY signalo_db.dms_rel_document ADD CONSTRAINT dms_rel_document_pkey PRIMARY KEY (id);

ALTER TABLE ONLY signalo_db.dms_rel_document
  ADD CONSTRAINT fk_document FOREIGN KEY (fk_document)
  REFERENCES signalo_db.dms_document(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;
