-- Viewer receipts are necessary to revoke cached entities without revealing unseen IDs.
-- Content stays in the source tables; this append-only log stores metadata only.
CREATE TABLE app.offline_memory_changes (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id uuid NOT NULL REFERENCES app.families(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES app.users(id) ON DELETE CASCADE,
  entity varchar(20) NOT NULL CHECK (entity IN ('memory','memoryComment','memoryReaction')),
  entity_id text NOT NULL,
  memory_id uuid NOT NULL,
  op varchar(6) NOT NULL CHECK (op IN ('upsert','delete')),
  fingerprint text NOT NULL,
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3)
);
CREATE INDEX ix_offline_changes_cursor ON app.offline_memory_changes(family_id,user_id,updated_at,id) WHERE deleted_at IS NULL;
CREATE INDEX ix_offline_changes_latest ON app.offline_memory_changes(family_id,user_id,entity,entity_id,updated_at DESC,id DESC) WHERE deleted_at IS NULL;
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.offline_memory_changes FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();
