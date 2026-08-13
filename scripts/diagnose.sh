#!/usr/bin/env bash
set -Eeuo pipefail

FAIL=0

echo "=== Git ==="

git rev-parse --is-inside-work-tree >/dev/null ||
  FAIL=1

echo "=== Files ==="

for FILE in \
  Dockerfile \
  nginx/default.conf \
  site/index.html
do

  if [ -s "$FILE" ]
  then
    echo "✅ $FILE"
  else
    echo "❌ $FILE"
    FAIL=1
  fi

done

echo "=== Bash ==="

for FILE in scripts/*.sh
do

  if bash -n "$FILE"
  then
    echo "✅ $FILE"
  else
    echo "❌ $FILE"
    FAIL=1
  fi

done

echo "=== Secrets ==="

./scripts/secret-scan.sh ||
  FAIL=1

echo "=== GitHub ==="

gh auth status >/dev/null 2>&1 ||
  FAIL=1

exit "$FAIL"
