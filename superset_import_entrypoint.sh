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

# Импортируем базы, датасеты, дашборды и чарты
for TYPE in databases datasets dashboards charts; do
    for f in /app/data/$TYPE/*.zip; do
        [ -e "$f" ] || continue
        echo "Importing $TYPE: $f"
        superset import-$TYPE -p "$f" || true
    done
done

touch "$IMPORT_MARKER"

echo "=== Imports finished. Starting Superset ==="
exec superset run -p 8088 -h 0.0.0.0
