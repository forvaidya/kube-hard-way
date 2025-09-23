set -euo pipefail

# Install containerd from Ubuntu repo (good enough), then harden config
sudo apt-get install -y containerd

# Generate default config
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

# Use systemd cgroup driver for kubelet compatibility
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Ensure sandbox (pause) image is reachable (defaults are fine for 1.29+)
sudo systemctl enable --now containerd
sudo systemctl restart containerd
