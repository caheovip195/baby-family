#!/usr/bin/env bash
set -euo pipefail
umask 077

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if [[ $# -ne 0 ]]; then
  printf '%s\n' 'Usage: backup.sh' >&2
  exit 64
fi

destination="$(backup_directory)"
mkdir -p "$destination"
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
temporary_directory="$(mktemp -d "$destination/.backup-$timestamp.XXXXXX")"
suffix="${temporary_directory##*.}"
dump_file="$destination/baby-family-$timestamp-$suffix.dump"
globals_file="$destination/baby-family-$timestamp-$suffix.globals.sql"
globals_published=false
dump_published=false
completed=false

cleanup() {
  local status=$?
  trap - EXIT
  if [[ "$completed" != true ]]; then
    if [[ "$dump_published" == true ]]; then rm -f "$dump_file"; fi
    if [[ "$globals_published" == true ]]; then rm -f "$globals_file"; fi
  fi
  rm -f "$temporary_directory/database.dump" "$temporary_directory/globals.sql"
  rmdir "$temporary_directory"
  exit "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
trap 'exit 129' HUP

if [[ -e "$dump_file" || -e "$globals_file" ]]; then
  printf '%s\n' 'Backup destination already exists; refusing to overwrite it.' >&2
  exit 1
fi

compose exec -T postgres sh -eu -c \
  'exec pg_dump --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --format=custom' \
  > "$temporary_directory/database.dump"
compose exec -T postgres sh -eu -c \
  'exec pg_dumpall --username "$POSTGRES_USER" --globals-only' \
  > "$temporary_directory/globals.sql"
compose exec -T postgres pg_restore --format=custom --list \
  < "$temporary_directory/database.dump" > /dev/null

# Publish the archive last; an existing .dump means both files are complete.
mv "$temporary_directory/globals.sql" "$globals_file"
globals_published=true
mv "$temporary_directory/database.dump" "$dump_file"
dump_published=true
completed=true
printf 'Globals backup: %s\n' "$globals_file" >&2
printf '%s\n' "$dump_file"
