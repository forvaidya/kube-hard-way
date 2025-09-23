set -euo pipefail
if [ -f /tmp/join.sh ]; then
  sudo bash /tmp/join.sh
else
  echo "/tmp/join.sh not found. Paste the kubeadm join command here:"
  exit 1
fi
