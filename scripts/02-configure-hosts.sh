#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <server1-ip> <server2-ip>"
  echo "Example: $0 192.168.56.101 192.168.56.102"
  exit 1
fi

SERVER1_IP="$1"
SERVER2_IP="$2"

sed -i '/[[:space:]]server1\([[:space:]]\|$\)/d' /etc/hosts
sed -i '/[[:space:]]server2\([[:space:]]\|$\)/d' /etc/hosts

printf '%s\tserver1\n' "$SERVER1_IP" >> /etc/hosts
printf '%s\tserver2\n' "$SERVER2_IP" >> /etc/hosts

echo "Updated /etc/hosts:"
grep -E '[[:space:]]server[12]([[:space:]]|$)' /etc/hosts
