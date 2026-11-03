-- BF-20261028-006: REC-01 Câu chuyện ngày — bố mẹ gói ký ức một ngày của bé
-- thành câu chuyện (tiêu đề, đoạn văn, ảnh chọn từ ký ức trong ngày). DDL only.
CREATE TABLE app.day_stories (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id uuid NOT NULL REFERENCES app.families(id),
  child_id uuid NOT NULL REFERENCES app.children(id),
  local_date date NOT NULL,
  title varchar(120) NOT NULL CHECK (length(btrim(title)) > 0),
  body varchar(5000),
  cover_asset_id uuid REFERENCES app.assets(id),
  memory_ids uuid[] NOT NULL DEFAULT '{}',
  asset_ids uuid[] NOT NULL DEFAULT '{}',
  visibility app.visibility NOT NULL DEFAULT 'PARENTS',
  created_by uuid NOT NULL REFERENCES app.users(id),
  updated_by uuid NOT NULL REFERENCES app.users(id),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3),
  CHECK (cardinality(asset_ids) <= 30),
  CHECK (cardinality(memory_ids) <= 100)
);
CREATE UNIQUE INDEX uq_day_story_child_day
  ON app.day_stories (child_id, local_date)
  WHERE deleted_at IS NULL;
CREATE INDEX ix_day_stories_family
  ON app.day_stories (family_id, local_date)
  WHERE deleted_at IS NULL;
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.day_stories
FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();
