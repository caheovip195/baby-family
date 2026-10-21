-- BF-20261021-008: fingerprint of the original file on the uploader's device
-- (client-processed media), so the app can show its own gallery copy instead of
-- downloading. `captured_at` already exists. DDL only.
ALTER TABLE app.assets
  ADD COLUMN source_sha256 bytea,
  ADD COLUMN source_key varchar(64),
  ADD CONSTRAINT ck_asset_source_sha256 CHECK (source_sha256 IS NULL OR octet_length(source_sha256) = 32);
