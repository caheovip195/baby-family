-- BF-20261017-001: SHA-256 dedup is scoped per uploader. Another Parent's copy is
-- reused only when it is already visible to the uploader (application check), so
-- both Parents may each hold their own copy of the same content.
DROP INDEX app.uq_asset_dedup;
CREATE UNIQUE INDEX uq_asset_dedup ON app.assets(family_id, purpose, private_owner_user_id, uploader_user_id, sha256) NULLS NOT DISTINCT WHERE sha256 IS NOT NULL AND deleted_at IS NULL;
