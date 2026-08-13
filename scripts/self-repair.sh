#!/usr/bin/env bash
set -Eeuo pipefail

MAX=3
TRY=1

while [ "$TRY" -le "$MAX" ]
do

  echo
  echo "================================"
  echo " REPAIR POGING $TRY/$MAX"
  echo "================================"

  if ./scripts/diagnose.sh
  then
    echo "✅ Diagnose geslaagd"
    exit 0
  fi

  echo "⚠️ Problemen gevonden"

  chmod +x scripts/*.sh

  if [ ! -s site/index.html ]
  then
    ./scripts/sync-site.sh "$HOME/mikis13-site"
  fi

  if [ ! -s Dockerfile ]
  then
    echo "❌ Dockerfile ontbreekt"
    exit 1
  fi

  TRY=$((TRY+1))

done

echo "❌ Reparatie na $MAX pogingen niet geslaagd"
exit 1
