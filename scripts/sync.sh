#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
export LANG=C.UTF-8; export LC_ALL=C.UTF-8
MSG="${1:-}"
[ -n "$MSG" ] || { echo "Usage: ./scripts/sync.sh \"commit message\""; exit 2; }

git add -A
if git diff --cached --quiet; then
  echo "ℹ️ nothing to commit"
else
  git commit -m "$MSG" || true
fi

git fetch origin >/dev/null 2>&1 || true

# If origin/main does not exist yet (empty remote), do first push without rebase
if ! git show-ref --verify --quiet refs/remotes/origin/main; then
  git push -u origin main
  echo "✅ pushed safely (first upstream created)"
  exit 0
fi

git rebase --autostash origin/main || { echo "❌ rebase conflict"; git status -sb; exit 3; }
git push origin main
echo "✅ pushed safely"
