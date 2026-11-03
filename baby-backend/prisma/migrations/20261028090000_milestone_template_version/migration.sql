-- BF-20261028-003: catalog cột mốc có version (DDL only; publish/retire do Admin CMS).
ALTER TABLE app.milestone_templates
  ADD COLUMN version integer NOT NULL DEFAULT 1;
ALTER TABLE app.milestone_templates
  ADD CONSTRAINT milestone_templates_version_check CHECK (version > 0);
