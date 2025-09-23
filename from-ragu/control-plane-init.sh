#!/bin/bash
set -e

MASTER_IP="$1"

if [ -z "$MASTER_IP" ]; then
  echo "[ERROR] Usage: $0 <Master_Private_IP>"
  exit 1
fi

echo "[INFO] Initializing control plane..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address="$MASTER_IP"

echo "[INFO] Setting up kubectl for current user..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[INFO] Installing Calico CNI..."
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo "[INFO] Control plane setup complete."
echo "[NOTE] Save the kubeadm join command shown above for worker nodes."