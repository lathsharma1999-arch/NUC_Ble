#!/bin/bash
# /config/batmon_source/nuc_ble/ → /addons/batmon/ re-apply

SRC="/config/batmon_source/nuc_ble"
DST="/addons/batmon"
PATCH_LIST="/config/batmon_source/PATCHED_FILES"

echo "�� Pulling latest from GitHub..."
cd /config/batmon_source && git pull

echo "🩹 Restoring patched files to addon..."

while IFS= read -r file; do
  [ -z "$file" ] && continue
  src_file="$SRC/$file"
  dst_file="$DST/$file"

  if [ ! -f "$src_file" ]; then
    echo "⚠️  Not in repo: $file"
    continue
  fi

  cp "$src_file" "$dst_file"
  echo "✅ Restored: $file"
done < "$PATCH_LIST"

echo ""
echo "🔄 Rebuilding addon..."
ha addons stop local_batmon
ha addons rebuild local_batmon
ha addons start local_batmon
echo "✅ Done! Addon restarted with patches applied."
