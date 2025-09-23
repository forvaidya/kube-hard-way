## STEPS TO USE SCRIPTS


- On every node (control plane + workers): 00-common.sh → choose either 10-install-containerd.sh or 10-install-docker-cri.sh → 20-install-kubernetes.sh

- On control plane: 30-control-plane-init.sh → 31-install-calico.sh → 50-save-join.sh

- On each worker: run the join command saved by step 50 (or just run 40-worker-join.sh if you copied the file).

- set proper hostnames (ex: ip-10-0-1-10), match DNS if you can.

- security groups: open 6443 to workers, and node-to-node ports (10250, etcd 2379-2380 between control-plane members, CNI ports).

- pick a pod CIDR and stick to it. I used 10.244.0.0/16 (Calico/Flannel-friendly).

### 0) Set your variables once (copy & tweak)

- Use these same values on all nodes unless noted.
- env.sh - source this before scripts, or export inline in shell

### 1) Common baseline (all nodes)

- Use 00-common.sh

### 2A) Install containerd runtime (recommended): Use 10-install-containerd.sh
### 2B) (Optional) Install Docker + cri-dockerd (only if you really need Docker): Use 10-install-docker-cri.sh

### 3) Install kubeadm/kubelet/kubectl (all nodes): Use 20-install-kubernetes.sh

### 4) Initialize the control plane (control plane node only): Use 30-control-plane-init.sh

### 5) Install CNI (Calico example; control plane): Use 31-install-calico.sh

### 6) Save/Share the worker join command (control plane): Use 50-save-join.sh

### 7) Join workers (worker nodes): Use 40-worker-join.sh

### 8) Verify (control plane): Use 60-verify.sh

---

sanity checklist
=================

EC2 Security Groups

Control plane inbound: 6443 from worker SG; 22 from your IP; 2379-2380 from control-plane SG (if HA later).

Workers inbound: 10250 from control-plane SG; node-to-node as needed; app ports if you expose NodePort.

Hostnames resolve (or /etc/hosts) across nodes.

Swap off everywhere.

Same K8s minor version across nodes.

If pods are ContainerCreating forever -> CNI not applied or CIDR mismatch.

If kubelet not Ready -> container runtime socket or cgroup driver mismatch.

using Docker path? here's your kubeadm flags

init:
kubeadm init ... --cri-socket=unix:///var/run/cri-dockerd.sock

join:
kubeadm join ... --cri-socket=unix:///var/run/cri-dockerd.sock

---

After cluster is Ready: quick webserver test (nginx)

kubectl create deploy nginx --image=nginx:1.25
kubectl expose deploy nginx --port=80 --type=NodePort
kubectl get svc nginx -o wide
# then curl http://<any_worker_private_ip>:<nodePort>  (from within VPC)
# for public access, add an ALB/NLB or an Ingress Controller + ALB.



# CONCLUSION

Use containerd unless you have a hard Docker requirement. It’s faster to get right, fewer weird shims.

For public web access, don’t punch NodePorts to the internet. Use Ingress + ALB or a Service type=LoadBalancer with the AWS cloud-controller.
