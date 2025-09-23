set -euo pipefail

# token valid 24h by default; adjust if you want a long-lived token
sudo kubeadm token create --print-join-command | tee /tmp/join.sh
chmod +x /tmp/join.sh
echo "Join command saved to /tmp/join.sh"
cat /tmp/join.sh
