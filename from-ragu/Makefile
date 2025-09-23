SHELL := /bin/bash
S := from-ragu/scripts

.PHONY: cp-init worker-init verify docker-runtime

# load env for each target (expects APISERVER_ADVERTISE_ADDRESS set on control plane)
define load_env
	set -a; source $(S)/env.sh 2>/dev/null || true; set +a
endef

cp-init:
	@$(load_env); set -euxo pipefail; \
	bash $(S)/00-common.sh; \
	bash $(S)/10-install-containerd.sh; \
	bash $(S)/20-install-kubernetes.sh; \
	bash $(S)/30-control-plane-init.sh; \
	bash $(S)/31-install-calico.sh; \
	bash $(S)/50-save-join.sh

worker-init:
	@$(load_env); set -euxo pipefail; \
	bash $(S)/00-common.sh; \
	bash $(S)/10-install-containerd.sh; \
	bash $(S)/20-install-kubernetes.sh; \
	bash $(S)/40-worker-join.sh

verify:
	@set -euxo pipefail; bash $(S)/60-verify.sh

docker-runtime:
	@$(load_env); set -euxo pipefail; \
	bash $(S)/10-install-docker-cri.sh


# Usage: 
############################################
# control plane
# export APISERVER_ADVERTISE_ADDRESS=<master_private_ip>
# make cp-init

# each worker
# make worker-init

# sanity
# make verify




