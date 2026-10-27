-- The encrypted candidate content remains in the existing couple-scoped table.
-- Nullable keys preserve existing ciphertext without a migration-time backfill.
ALTER TABLE us.pregnancy_name_candidates
  ADD COLUMN name_key varchar(64);

CREATE UNIQUE INDEX uq_pregnancy_name_key_active
  ON us.pregnancy_name_candidates (pregnancy_id, name_key)
  WHERE deleted_at IS NULL AND name_key IS NOT NULL;
