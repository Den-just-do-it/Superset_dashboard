#!/usr/bin/env bash
set -euo pipefail

# Скрипт меняет clickhouse+native -> clickhouse+connect и :9000 -> :8123
# Обрабатывает все .zip в подпапках data/* и сохраняет резервную копию original.bak.zip

ROOT_DIR="$(pwd)"
DATA_DIR="$ROOT_DIR/data"

if [ ! -d "$DATA_DIR" ]; then
  echo "Ошибка: папка data/ не найдена в $(pwd)"
  exit 1
fi

echo "Будут обработаны ZIP-файлы в $DATA_DIR/* (резервные копии с .bak.zip)."
read -p "Продолжить? [y/N] " CONF
if [[ "$CONF" != "y" && "$CONF" != "Y" ]]; then
  echo "Отменено."
  exit 0
fi

tmpd="$(mktemp -d)"
trap 'rm -rf "$tmpd"' EXIT

changed=0
for zip in "$DATA_DIR"/*/*.zip; do
  [ -e "$zip" ] || continue
  echo
  echo "Обработка: $zip"

  # резервная копия (если её нет)
  bak="${zip%.zip}.bak.zip"
  if [ ! -f "$bak" ]; then
    cp -v "$zip" "$bak"
  else
    echo "  Резервная копия уже есть: $(basename "$bak")"
  fi

  # распаковать в tmp
  workdir="$tmpd/$(basename "$zip" .zip)"
  mkdir -p "$workdir"
  unzip -q "$zip" -d "$workdir"

  # найти yaml файлы и сделать замены
  files_changed=0
  while IFS= read -r -d '' f; do
    # заменяем строки в файле
    # сначала про запас сохраняем оригинал локально (в папке workdir)
    cp -n "$f" "$f.orig" 2>/dev/null || true
    # делаем замены
    perl -0777 -pe 's/clickhouse\+native/clickhouse+connect/g; s/:(9000|9000\/)/:8123\//g; s/:9000\b/:8123/g' -i "$f"
    # проверим, изменился ли файл по сравнению с .orig
    if ! cmp -s "$f" "$f.orig"; then
      echo "  Изменён: ${f#$workdir/}"
      files_changed=$((files_changed+1))
    fi
  done < <(find "$workdir" -type f \( -iname '*.yaml' -o -iname '*.yml' -o -iname '*.json' \) -print0)

  if [ "$files_changed" -gt 0 ]; then
    # пересобрать zip
    (cd "$workdir" && zip -qr "$tmpd/new.zip" .)
    mv -v "$tmpd/new.zip" "$zip"
    echo "  Пересобран и заменён архив: $(basename "$zip")"
    changed=$((changed+1))
  else
    echo "  Файлы YAML не содержали целевых строк — архив не изменён."
  fi

done

echo
echo "Готово. Изменено архивов: $changed"
echo "Резервные копии находятся рядом с оригиналами (*.bak.zip)."
echo "Проверь один из пересобранных архивов вручную (unzip -l ...) и открой YAML чтобы убедиться."

