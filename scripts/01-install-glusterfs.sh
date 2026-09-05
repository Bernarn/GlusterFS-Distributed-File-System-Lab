#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

apt update
apt upgrade -y
apt install -y glusterfs-server

systemctl enable --now glusterd
systemctl status glusterd --no-pager

echo "GlusterFS installation completed."
