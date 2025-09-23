set -euo pipefail
kubectl get nodes -o wide
kubectl -n kube-system get pods -o wide
