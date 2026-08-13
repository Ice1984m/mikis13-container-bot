#!/usr/bin/env bash
set -Eeuo pipefail

NAME="mikis13-local-test"

if ! proot-distro build --help >/dev/null 2>&1
then
  echo "⚠️ proot-distro build niet beschikbaar"
  exit 20
fi

proot-distro remove "$NAME" \
  >/dev/null 2>&1 || true

echo "Lokale OCI build starten..."

timeout 8m \
  proot-distro build \
    -t "$NAME:latest" \
    --install-as "$NAME" \
    .

RC=$?

if [ "$RC" -ne 0 ]
then
  proot-distro remove "$NAME" >/dev/null 2>&1 || true
  exit "$RC"
fi

timeout 60 \
  proot-distro login "$NAME" \
  -- /usr/sbin/nginx -t

proot-distro remove "$NAME" \
  >/dev/null 2>&1 || true

echo "✅ Lokale OCI build OK"
