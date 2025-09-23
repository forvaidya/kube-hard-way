set -euo pipefail

# Calico manifest (works with 10.244.0.0/16 by default). If you changed POD_CIDR, update the config map in the manifest.
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Wait for calico pods to come up
echo "Waiting for Calico to be Ready..."
kubectl -n kube-system wait --for=condition=Ready pods --all --timeout=300s
