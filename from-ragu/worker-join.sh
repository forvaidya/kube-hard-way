#!/bin/bash
set -e

JOIN_CMD="$1"

if [ -z "$JOIN_CMD" ]; then
  echo "[ERROR] Usage: $0 '<kubeadm join command>'"
  exit 1
fi

echo "[INFO] Joining worker node to cluster..."
sudo $JOIN_CMD

echo "[INFO] Worker node joined successfully."