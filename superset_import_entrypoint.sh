#!/bin/sh
set -euo pipefail

echo "=== Superset: DB upgrade, admin (idempotent) and init ==="

superset db upgrade

superset fab create-admin \
    --username "${SUPERSET_ADMIN_USERNAME:-guest}" \
    --firstname "${SUPERSET_ADMIN_FIRST_NAME:-Guest}" \
    --lastname "${SUPERSET_ADMIN_LAST_NAME:-User}" \
    --email "${SUPERSET_ADMIN_EMAIL:-guest@example.com}" \
    --password "${SUPERSET_ADMIN_PASSWORD:-guest}" || true

superset init

echo "=== NOTE: Automatic import of dashboards/datasets is skipped to avoid CLI incompatibilities ==="
echo "If you want to import backups, do it manually from the UI or we will add a safe import flow next."

exec superset run -p 8088 -h 0.0.0.0
