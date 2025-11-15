#!/bin/sh
set -euo pipefail

echo "=== Starting Superset DB upgrade and admin creation ==="

superset db upgrade

superset fab create-admin \
    --username "$SUPERSET_ADMIN_USERNAME" \
    --firstname "$SUPERSET_ADMIN_FIRST_NAME" \
    --lastname "$SUPERSET_ADMIN_LAST_NAME" \
    --email "$SUPERSET_ADMIN_EMAIL" \
    --password "$SUPERSET_ADMIN_PASSWORD"

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
    superset import-database -p "$f"
done

echo "=== Importing datasets ==="
for f in /app/data/datasets/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing dataset: $f"
    superset import-dataset -p "$f"
done

echo "=== Importing dashboards ==="
for f in /app/data/dashboards/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing dashboard: $f"
    superset import-dashboard -p "$f"
done

echo "=== Importing charts ==="
for f in /app/data/charts/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing chart: $f"
    superset import-chart -p "$f"
done

touch "$IMPORT_MARKER"

echo "=== Imports finished. Starting Superset ==="
exec superset run -p 8088 -h 0.0.0.0
