#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
export LANG=C.UTF-8; export LC_ALL=C.UTF-8
TS="$(date -Iseconds)"
OUT="snapshots/snapshot_${TS}.txt"
OUT="$(printf "%s" "$OUT" | sed "s/:/-/g")"
{
  echo "TIME: $TS"
  echo
  echo "=== TERMUX-INFO (first 120 lines) ==="
  termux-info 2>/dev/null | head -n 120 || echo "termux-info failed"
  echo
  echo "=== VERSIONS ==="
  git --version 2>/dev/null || true
  node -v 2>/dev/null || true
  python --version 2>/dev/null || true
  ssh -V 2>&1 | head -n 1 || true
  echo
  echo "=== REPO STATUS ==="
  git status -sb 2>/dev/null || true
  echo
  echo "=== NETWORK (github head) ==="
  curl -Is https://github.com 2>/dev/null | head -n 1 || true
} > "$OUT"
echo "$OUT"
