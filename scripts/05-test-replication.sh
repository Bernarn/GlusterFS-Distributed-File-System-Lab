#!/usr/bin/env bash
set -euo pipefail

MOUNT_POINT="${MOUNT_POINT:-/mnt/glusterfs}"
TEST_FILE="$MOUNT_POINT/test_success.txt"

if ! mountpoint -q "$MOUNT_POINT"; then
  echo "$MOUNT_POINT is not mounted. Mount the GlusterFS volume first."
  exit 1
fi

MESSAGE="Good morning class, this is our test file for this project"
printf '%s\n' "$MESSAGE" | sudo tee "$TEST_FILE" >/dev/null

echo "Created: $TEST_FILE"
echo "Contents:"
cat "$TEST_FILE"

echo
ls -la "$MOUNT_POINT"
