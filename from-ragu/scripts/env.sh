export K8S_VERSION="1.29"                    # major.minor for repo track
export K8S_PKGS_VERSION=""                   # empty = latest in track; or pin e.g. 1.29.8-1.1
export POD_CIDR="10.244.0.0/16"
export SERVICE_CIDR="10.96.0.0/12"           # default kubeadm uses this
export CLUSTER_NAME="aws-ec2-kube"
export APISERVER_ADVERTISE_ADDRESS="<MASTER_PRIVATE_IP>"   # set on control plane only
# Example: export APISERVER_ADVERTISE_ADDRESS="10.0.1.10"
