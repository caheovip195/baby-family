#!/usr/bin/env bash

# Shared path handling; Compose loads .env without executing it as shell code.
DATABASE_PROJECT_DIR="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

compose() {
  docker compose \
    --project-directory "$DATABASE_PROJECT_DIR" \
    --file "$DATABASE_PROJECT_DIR/compose.yaml" \
    "$@"
}

backup_directory() {
  local configured_path
  configured_path="$(compose config --environment | sed -n 's/^POSTGRES_BACKUP_DIR=//p')"
  if [[ -z "$configured_path" || "$configured_path" == *$'\n'* ]]; then
    printf '%s\n' 'POSTGRES_BACKUP_DIR must be a non-empty, single-line path.' >&2
    return 1
  fi
  case "$configured_path" in
    /*) printf '%s\n' "$configured_path" ;;
    *) printf '%s/%s\n' "$DATABASE_PROJECT_DIR" "$configured_path" ;;
  esac
}
