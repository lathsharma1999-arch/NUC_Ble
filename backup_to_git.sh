#!/bin/bash
# /addons/batmon/ → /config/batmon_source/nuc_ble/ sync

SRC="/addons/batmon"
DST="/config/batmon_source/nuc_ble"
PATCH_LIST="/config/batmon_source/PATCHED_FILES"

echo "🔄 Syncing patched files to git repo..."

while IFS= read -r file; do
  [ -z "$file" ] && continue
  src_file="$SRC/$file"
  dst_file="$DST/$file"

  if [ ! -f "$src_file" ]; then
    echo "⚠️  Not found in addon: $file"
    continue
  fi

  mkdir -p "$(dirname "$dst_file")"
  cp "$src_file" "$dst_file"
  echo "✅ Copied: $file"
done < "$PATCH_LIST"

cd /config/batmon_source
git add nuc_ble/
git diff --cached --quiet && echo "ℹ️  No changes to commit." && exit 0

git commit -m "sync: update patched files from addon $(date '+%Y-%m-%d %H:%M')"
git push
echo "🚀 Pushed to GitHub."
