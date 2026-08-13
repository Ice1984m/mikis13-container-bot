#!/usr/bin/env bash
set -Eeuo pipefail

SRC="${1:-$HOME/mikis13-site}"
DST="site"

[ -d "$SRC" ] || {
  echo "❌ Bronwebsite ontbreekt"
  exit 1
}

rm -rf "$DST"
mkdir -p "$DST"

find "$SRC" \
  -mindepth 1 \
  -maxdepth 1 \
  ! -name .git \
  ! -name node_modules \
  ! -name '.env*' \
  ! -name '*.key' \
  ! -name '*.token' \
  ! -name '*.pem' \
  ! -name '*.log' \
  ! -name '*.jsonl' \
  -exec cp -a {} "$DST/" \;

rm -f \
  "$DST/openai.key" \
  "$DST/security.env"

test -s "$DST/index.html" || {
  echo "❌ site/index.html ontbreekt"
  exit 1
}

echo "✅ Website sync OK"
