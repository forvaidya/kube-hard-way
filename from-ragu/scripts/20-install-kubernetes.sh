set -euo pipefail

: "${K8S_VERSION:=1.29}"
: "${K8S_PKGS_VERSION:=}"

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y

PKG_VER_ARG=""
if [ -n "${K8S_PKGS_VERSION}" ]; then
  PKG_VER_ARG="=${K8S_PKGS_VERSION}"
fi

sudo apt-get install -y kubelet${PKG_VER_ARG} kubeadm${PKG_VER_ARG} kubectl${PKG_VER_ARG}
sudo apt-mark hold kubelet kubeadm kubectl

# Ensure kubelet starts after container runtime is ready
sudo systemctl enable kubelet
