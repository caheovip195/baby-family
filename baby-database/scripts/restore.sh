#!/usr/bin/env bash
set -euo pipefail
umask 077

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if [[ $# -ne 2 ]]; then
  printf '%s\n' 'Usage: restore.sh <custom-dump-file> <new_database_name>' >&2
  exit 64
fi

dump_file=$1
target_database=$2
if [[ ! -f "$dump_file" || ! -r "$dump_file" || ! -s "$dump_file" ]]; then
  printf '%s\n' 'Dump file must exist, be readable, and be non-empty.' >&2
  exit 1
fi
case "$target_database" in
  ''|*[!a-z0-9_]*|[0-9_]*|postgres|template0|template1)
    printf '%s\n' 'Choose a new database name starting with a lowercase letter, using only a-z, 0-9 and underscore.' >&2
    exit 1
    ;;
esac
if [[ ${#target_database} -gt 63 ]]; then
  printf '%s\n' 'Database name must be at most 63 ASCII characters.' >&2
  exit 1
fi

configured_database="$(compose exec -T postgres sh -eu -c 'printf "%s" "$POSTGRES_DB"')"
if [[ "$target_database" == "$configured_database" ]]; then
  printf '%s\n' 'Refusing to restore over the configured application database.' >&2
  exit 1
fi

# Validate the archive before creating a target. createdb atomically refuses
# existing databases, including empty ones; there is deliberately no DROP.
compose exec -T postgres pg_restore --format=custom --list < "$dump_file" > /dev/null
compose exec -T postgres sh -eu -c \
  'exec createdb --username "$POSTGRES_USER" --maintenance-db postgres --template template0 --owner "$POSTGRES_USER" -- "$1"' \
  restore "$target_database"

if ! compose exec -T postgres sh -eu -c \
  'exec pg_restore --username "$POSTGRES_USER" --dbname "$1" --format=custom --single-transaction --exit-on-error --no-owner --no-privileges' \
  restore "$target_database" < "$dump_file"; then
  printf 'Restore failed. Newly created database %s remains; inspect it before retrying with another new name.\n' "$target_database" >&2
  exit 1
fi
printf 'Restored backup into new database: %s\n' "$target_database"
