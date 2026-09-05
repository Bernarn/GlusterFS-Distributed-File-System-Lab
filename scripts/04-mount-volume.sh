#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

SERVER="${1:-server1}"
VOLUME="${VOLUME:-gv0}"
MOUNT_POINT="${MOUNT_POINT:-/mnt/glusterfs}"

mkdir -p "$MOUNT_POINT"

if mountpoint -q "$MOUNT_POINT"; then
  echo "$MOUNT_POINT is already mounted."
else
  mount -t glusterfs "$SERVER:/$VOLUME" "$MOUNT_POINT"
fi

mount | grep "$MOUNT_POINT" || true
