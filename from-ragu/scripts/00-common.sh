set -euo pipefail

sudo swapoff -a
sudo sed -i.bak '/\sswap\s/ s/^/# /' /etc/fstab

# kernel modules
cat <<'EOF' | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl
cat <<'EOF' | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# time sync + basics
sudo apt-get update -y
sudo apt-get install -y chrony apt-transport-https ca-certificates curl gnupg lsb-release

# optional: disable swap service if present
sudo systemctl mask swap.target || true
