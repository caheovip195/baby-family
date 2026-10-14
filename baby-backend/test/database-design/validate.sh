#!/usr/bin/env bash
set -Eeuo pipefail

# Replay backend Prisma migrations and explicit seed in disposable PostgreSQL only.
design_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
backend_dir="$(cd -- "$design_dir/../.." && pwd)"
prisma_bin="$backend_dir/node_modules/.bin/prisma"
review_name="baby-family-design-$(date -u +%Y%m%dT%H%M%S)-$$"
review_id=""

cleanup() {
  if [[ -n "$review_id" ]]; then
    docker rm --force "$review_id" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

[[ -x "$prisma_bin" ]] || { printf 'Install backend dependencies first\n' >&2; exit 1; }
review_id="$(docker run --detach --rm --name "$review_name" \
  --label baby-family.purpose=database-design-validation \
  --publish 127.0.0.1::5432 --tmpfs /var/lib/postgresql:rw \
  --env POSTGRES_USER=design_check --env POSTGRES_DB=design_check \
  --env POSTGRES_PASSWORD=temporary_design_validation_only \
  postgres:18.6-bookworm)"

review_ready=false
for ((review_try=0; review_try<30; review_try++)); do
  if docker exec "$review_id" pg_isready -U design_check -d design_check >/dev/null 2>&1; then
    review_ready=true
    break
  fi
  sleep 1
done
if [[ "$review_ready" != true ]]; then
  docker logs --tail 30 "$review_id" >&2
  printf 'Isolated PostgreSQL did not become ready\n' >&2
  exit 1
fi

review_port="$(docker port "$review_id" 5432/tcp)"
review_port="${review_port##*:}"
export DATABASE_URL="postgresql://design_check:temporary_design_validation_only@127.0.0.1:$review_port/design_check"
(cd "$backend_dir" && "$prisma_bin" migrate deploy)
docker exec "$review_id" psql -X -v ON_ERROR_STOP=1 -U design_check -d design_check --quiet -c \
  "DO \$\$ BEGIN IF EXISTS (SELECT 1 FROM billing.plans) THEN RAISE EXCEPTION 'Migration must not seed catalog data'; END IF; END \$\$;"
(cd "$backend_dir" && "$prisma_bin" db seed)
catalog_digest_sql="SELECT md5(string_agg(data::text, '' ORDER BY entity, data::text)) FROM (SELECT 'plans' AS entity, to_jsonb(p) AS data FROM billing.plans p UNION ALL SELECT 'versions', to_jsonb(v) FROM billing.plan_versions v UNION ALL SELECT 'trial', to_jsonb(t) FROM billing.trial_policies t UNION ALL SELECT 'config', to_jsonb(c) FROM ops.app_config c) records"
first_digest="$(docker exec "$review_id" psql -X -U design_check -d design_check -At -c "$catalog_digest_sql")"
(cd "$backend_dir" && "$prisma_bin" db seed)
second_digest="$(docker exec "$review_id" psql -X -U design_check -d design_check -At -c "$catalog_digest_sql")"
[[ "$first_digest" == "$second_digest" ]] || { printf 'Repeated seed changed existing catalog data\n' >&2; exit 1; }
printf 'PASS: migrate deploy leaves catalog empty; explicit seed is idempotent\n'
docker exec -i "$review_id" psql -X -v ON_ERROR_STOP=1 -U design_check -d design_check --quiet < "$design_dir/assertions.sql"
docker exec -i "$review_id" psql -X -v ON_ERROR_STOP=1 -U design_check -d design_check --quiet < "$design_dir/scenarios.sql"

(cd "$backend_dir" && "$prisma_bin" validate)
printf 'PASS: backend migrations, seed and domain assertions; isolated container will be removed\n'
