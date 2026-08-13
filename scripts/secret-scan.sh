#!/usr/bin/env bash
set -Eeuo pipefail

PATTERN='sk-proj-[A-Za-z0-9_-]{20,}|github_pat_[A-Za-z0-9_]{20,}|gh[pousr]_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}'

FOUND=0

while IFS= read -r FILE
do
  [ -f "$FILE" ] || continue

  case "$FILE" in
    ./scripts/secret-scan.sh)
      continue
      ;;
  esac

  if grep -E "$PATTERN" "$FILE" >/dev/null 2>&1
  then
    echo "❌ Mogelijke secret: $FILE"
    FOUND=1
  fi

done < <(
  find . \
    -type f \
    ! -path './.git/*' \
    ! -path './reports/*'
)

[ "$FOUND" -eq 0 ] || exit 1

echo "✅ Secret scan OK"
