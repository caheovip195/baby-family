-- BF-20261028-007: Bàn giao ca (7.13.8) — Parent ghi nhanh tình trạng bé (đã
-- ăn / ngủ / dậy lúc, ghi chú) cho bạn đời; ghi chú mã hoá theo couple space.
-- Không phải tracker y tế. DDL only.
CREATE TABLE us.care_handoffs (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  family_id uuid NOT NULL REFERENCES app.families(id),
  couple_space_id uuid NOT NULL REFERENCES app.couple_spaces(id),
  from_user_id uuid NOT NULL REFERENCES app.users(id),
  to_user_id uuid NOT NULL REFERENCES app.users(id),
  idempotency_key uuid NOT NULL,
  child_ids uuid[] NOT NULL DEFAULT '{}',
  fed_at timestamptz(3),
  slept_at timestamptz(3),
  woke_at timestamptz(3),
  note_enc bytea CHECK (note_enc IS NULL OR octet_length(note_enc) > 29),
  request_id uuid REFERENCES us.requests(id),
  acknowledged_at timestamptz(3),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3),
  CHECK (from_user_id <> to_user_id),
  CHECK (cardinality(child_ids) <= 10),
  CHECK (fed_at IS NOT NULL OR slept_at IS NOT NULL OR woke_at IS NOT NULL OR note_enc IS NOT NULL)
);
CREATE UNIQUE INDEX uq_care_handoff_key
  ON us.care_handoffs (from_user_id, idempotency_key);
CREATE INDEX ix_care_handoffs_space
  ON us.care_handoffs (couple_space_id, created_at DESC)
  WHERE deleted_at IS NULL;
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON us.care_handoffs
FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();
