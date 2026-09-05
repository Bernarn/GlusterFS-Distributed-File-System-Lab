#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

SERVER1="${1:-server1}"
SERVER2="${2:-server2}"
VOLUME="${VOLUME:-gv0}"
BRICK="${BRICK:-/data/brick/gv0}"

mkdir -p "$BRICK"

echo "Probing peer: $SERVER2"
gluster peer probe "$SERVER2"

echo "Current peer status:"
gluster peer status

if gluster volume info "$VOLUME" >/dev/null 2>&1; then
  echo "Volume '$VOLUME' already exists."
else
  gluster volume create "$VOLUME" replica 2 \
    "$SERVER1:$BRICK" \
    "$SERVER2:$BRICK" force
fi

gluster volume start "$VOLUME" || true

gluster volume info "$VOLUME"
