#!/usr/bin/env bash
# Create baby-storage/.env from .env.example with random local secrets and the data folders.
# Never overwrites an existing .env. Secrets are not printed.
set -euo pipefail
umask 077

storage_dir="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
env_file="$storage_dir/.env"

if [[ -e "$env_file" ]]; then
  printf '%s\n' ".env already exists; keeping it." >&2
else
  secret() { head -c 48 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | cut -c1-32; }
  sed \
    -e "s/^VALKEY_PASSWORD=.*/VALKEY_PASSWORD=$(secret)/" \
    -e "s/^MINIO_ROOT_PASSWORD=.*/MINIO_ROOT_PASSWORD=$(secret)/" \
    -e "s/^MINIO_APP_SECRET_KEY=.*/MINIO_APP_SECRET_KEY=$(secret)/" \
    "$storage_dir/.env.example" > "$env_file"
  printf '%s\n' "Created $env_file" >&2
fi

data_dir="$(sed -n 's/^STORAGE_DATA_DIR=//p' "$env_file")"
case "$data_dir" in
  /*) ;;
  *) data_dir="$storage_dir/${data_dir#./}" ;;
esac
mkdir -p "$data_dir/valkey" "$data_dir/minio" "$data_dir/mailpit"
printf '%s\n' "Data folders ready under $data_dir" >&2
