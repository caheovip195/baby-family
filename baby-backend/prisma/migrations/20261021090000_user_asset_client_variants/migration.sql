-- Durable client declarations for account avatar upload sessions; no data mutation.
CREATE TABLE app.user_asset_variants (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  asset_id uuid NOT NULL,
  owner_user_id uuid NOT NULL,
  variant_code varchar(30) NOT NULL,
  storage_bucket varchar(80) NOT NULL,
  storage_key text NOT NULL,
  mime varchar(80) NOT NULL,
  size_bytes bigint NOT NULL CHECK (size_bytes > 0),
  verified_size_bytes bigint CHECK (verified_size_bytes > 0),
  checksum_sha256 bytea NOT NULL CHECK (octet_length(checksum_sha256) = 32),
  width integer CHECK (width > 0),
  height integer CHECK (height > 0),
  created_at timestamptz(3) NOT NULL DEFAULT now(),
  updated_at timestamptz(3) NOT NULL DEFAULT now(),
  deleted_at timestamptz(3),
  CONSTRAINT user_asset_variants_owner_fk FOREIGN KEY (asset_id, owner_user_id)
    REFERENCES app.user_assets(id, owner_user_id),
  CONSTRAINT user_asset_variants_asset_id_variant_code_key UNIQUE (asset_id, variant_code),
  CONSTRAINT user_asset_variants_storage_bucket_storage_key_key UNIQUE (storage_bucket, storage_key)
);
CREATE INDEX user_asset_variants_owner_user_id_idx ON app.user_asset_variants(owner_user_id);
CREATE TRIGGER trg_audit_update BEFORE UPDATE ON app.user_asset_variants
FOR EACH ROW EXECUTE FUNCTION ops.touch_audit_columns();
