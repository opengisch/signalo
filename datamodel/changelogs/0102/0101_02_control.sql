ALTER TABLE signalo_db.support DROP COLUMN _edited;
ALTER TABLE signalo_db.azimut DROP COLUMN _edited;
ALTER TABLE signalo_db.frame DROP COLUMN _edited;
ALTER TABLE signalo_db.sign DROP COLUMN _edited;

ALTER TABLE signalo_db.support ADD COLUMN needs_validation boolean not null default false;
ALTER TABLE signalo_db.azimut ADD COLUMN needs_validation boolean not null default false;
ALTER TABLE signalo_db.frame ADD COLUMN needs_validation boolean not null default false;
ALTER TABLE signalo_db.sign ADD COLUMN needs_validation boolean not null default false;

ALTER TABLE signalo_db.support ADD COLUMN _last_modification_platform text default null;
ALTER TABLE signalo_db.azimut ADD COLUMN _last_modification_platform text default null;
ALTER TABLE signalo_db.frame ADD COLUMN _last_modification_platform text default null;
ALTER TABLE signalo_db.sign ADD COLUMN _last_modification_platform text default null;

ALTER TABLE signalo_db.support RENAME COLUMN _last_modified_date TO _last_modification_date;
ALTER TABLE signalo_db.azimut RENAME COLUMN _last_modified_date TO _last_modification_date;
ALTER TABLE signalo_db.frame RENAME COLUMN _last_modified_date TO _last_modification_date;
ALTER TABLE signalo_db.sign RENAME COLUMN _last_modified_date TO _last_modification_date;

ALTER TABLE signalo_db.support RENAME COLUMN _last_modified_user TO _last_modification_user;
ALTER TABLE signalo_db.azimut RENAME COLUMN _last_modified_user TO _last_modification_user;
ALTER TABLE signalo_db.frame RENAME COLUMN _last_modified_user TO _last_modification_user;
ALTER TABLE signalo_db.sign RENAME COLUMN _last_modified_user TO _last_modification_user;

ALTER TABLE signalo_db.support RENAME COLUMN _inserted_date TO _creation_date;
ALTER TABLE signalo_db.azimut RENAME COLUMN _inserted_date TO _creation_date;
ALTER TABLE signalo_db.frame RENAME COLUMN _inserted_date TO _creation_date;
ALTER TABLE signalo_db.sign RENAME COLUMN _inserted_date TO _creation_date;

ALTER TABLE signalo_db.support RENAME COLUMN _inserted_user TO _creation_user;
ALTER TABLE signalo_db.azimut RENAME COLUMN _inserted_user TO _creation_user;
ALTER TABLE signalo_db.frame RENAME COLUMN _inserted_user TO _creation_user;
ALTER TABLE signalo_db.sign RENAME COLUMN _inserted_user TO _creation_user;
