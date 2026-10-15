#!/bin/sh
# Bucket layout follows docs/02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md §10.1; bf-user-media matches
# the Prisma default for private journal assets. Idempotent: re-running keeps existing objects.
set -eu

: "${MINIO_ROOT_USER:?}" "${MINIO_ROOT_PASSWORD:?}" "${MINIO_APP_ACCESS_KEY:?}" "${MINIO_APP_SECRET_KEY:?}"

endpoint="http://baby-minio:9000"
private_buckets="bf-media bf-user-media bf-exports"
public_bucket="bf-public"

attempt=0
until mc alias set local "$endpoint" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" >/dev/null 2>&1 \
  && mc ready local >/dev/null 2>&1; do
  attempt=$((attempt + 1))
  if [ "$attempt" -ge 30 ]; then
    echo "MinIO not ready after 30 attempts" >&2
    exit 1
  fi
  sleep 2
done

for bucket in $private_buckets $public_bucket; do
  mc mb --ignore-existing "local/$bucket" >/dev/null
done

for bucket in $private_buckets; do
  mc anonymous set none "local/$bucket" >/dev/null
done
mc anonymous set download "local/$public_bucket" >/dev/null

# Family media and private journals keep versions; noncurrent versions expire after 30 days.
for bucket in bf-media bf-user-media; do
  mc version enable "local/$bucket" >/dev/null
  if ! mc ilm rule ls "local/$bucket" 2>/dev/null | grep -q 'noncurrent'; then
    mc ilm rule add --noncurrent-expire-days 30 "local/$bucket" >/dev/null
  fi
done

# Data exports are temporary (7 days).
if ! mc ilm rule ls "local/bf-exports" 2>/dev/null | grep -q -i 'expir'; then
  mc ilm rule add --expire-days 7 "local/bf-exports" >/dev/null
fi

# Backend uses its own key limited to the project buckets, never the root credentials.
# DeleteObjectVersion/ListBucketVersions let the media worker erase raw uploads (GPS)
# completely instead of leaving them as noncurrent versions (BF-20261015-010).
policy_file="$(mktemp)"
cat > "$policy_file" <<'POLICY'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetBucketLocation", "s3:ListBucket", "s3:ListBucketVersions", "s3:ListBucketMultipartUploads"],
      "Resource": [
        "arn:aws:s3:::bf-media", "arn:aws:s3:::bf-user-media",
        "arn:aws:s3:::bf-exports", "arn:aws:s3:::bf-public"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:DeleteObjectVersion",
        "s3:AbortMultipartUpload", "s3:ListMultipartUploadParts"
      ],
      "Resource": [
        "arn:aws:s3:::bf-media/*", "arn:aws:s3:::bf-user-media/*",
        "arn:aws:s3:::bf-exports/*", "arn:aws:s3:::bf-public/*"
      ]
    }
  ]
}
POLICY
mc admin policy create local baby-backend-rw "$policy_file" >/dev/null
rm -f "$policy_file"
mc admin user add local "$MINIO_APP_ACCESS_KEY" "$MINIO_APP_SECRET_KEY" >/dev/null
mc admin policy attach local baby-backend-rw --user "$MINIO_APP_ACCESS_KEY" >/dev/null 2>&1 || true

echo "MinIO buckets and backend user ready"
