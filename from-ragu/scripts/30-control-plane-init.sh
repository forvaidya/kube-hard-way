set -euo pipefail
: "${APISERVER_ADVERTISE_ADDRESS:?need master private IP}"
: "${POD_CIDR:=10.244.0.0/16}"
: "${CLUSTER_NAME:=aws-ec2-kube}"

# If you used Docker+cri-dockerd, add: --cri-socket=unix:///var/run/cri-dockerd.sock
sudo kubeadm init \
  --apiserver-advertise-address="${APISERVER_ADVERTISE_ADDRESS}" \
  --pod-network-cidr="${POD_CIDR}" \
  --control-plane-endpoint="${APISERVER_ADVERTISE_ADDRESS}" \
  --upload-certs

# kubeconfig for current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown "$(id -u)":"$(id -g)" $HOME/.kube/config
kubectl cluster-info
