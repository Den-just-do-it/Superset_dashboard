set -euo pipefail

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

echo "Importing databases, datasets, dashboards from /app/data ..."

# 1) базы
for f in /app/data/databases/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing database: $f"
    superset import-databases -p "$f" -u "$SUPERSET_ADMIN_USERNAME" || superset import-databases -p "$f"
done

# 2) датасеты
for f in /app/data/datasets/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing dataset: $f"
    superset import-datasources -p "$f" -u "$SUPERSET_ADMIN_USERNAME" || superset import-datasources -p "$f"
done

# 3) дашборды
for f in /app/data/dashboards/*.zip; do
    [ -e "$f" ] || continue
    echo "Importing dashboard: $f"
    superset import-dashboards -p "$f" -u "$SUPERSET_ADMIN_USERNAME" || superset import-dashboards -p "$f"
done

touch "$IMPORT_MARKER"

echo "Imports finished."

exec superset run -p 8088 -h 0.0.0.0

