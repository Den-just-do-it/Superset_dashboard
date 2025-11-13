#!/bin/sh
set -euo pipefail

echo "=== Starting Superset DB upgrade and admin creation ==="

superset db upgrade

superset fab create-admin \
    --username "$SUPERSET_ADMIN_USERNAME" \
    --firstname "$SUPERSET_ADMIN_FIRST_NAME" \
    --lastname "$SUPERSET_ADMIN_LAST_NAME" \
    --email "$SUPERSET_ADMIN_EMAIL" \
    --password "$SUPERSET_ADMIN_PASSWORD" || true

superset init

IMPORT_MARKER="/app/.superset_import_done"

if [ -f "$IMPORT_MARKER" ]; then
  echo "Imports already done, skipping."
  exec superset run -p 8088 -h 0.0.0.0
fi

echo "=== Importing databases ==="
for f in /app/data/databases/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing database: $f"
    superset import-databases -p "$f" --force || true
done

echo "=== Importing datasets ==="
for f in /app/data/datasets/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing dataset: $f"
    superset import-datasources -p "$f" --force || true
done

echo "=== Importing dashboards ==="
for f in /app/data/dashboards/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing dashboard: $f"
    superset import-dashboards -p "$f" --force || true
done

touch "$IMPORT_MARKER"

echo "=== Imports finished. Starting Superset ==="
exec superset run -p 8088 -h 0.0.0.0
