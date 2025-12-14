#!/usr/bin/env bash
# Post-provision health check: all nodes Ready and system pods running.
set -euo pipefail

KUBECONFIG="${KUBECONFIG:-$(ls "$(dirname "$0")"/../kubeconfig-*.yaml | head -1)}"
export KUBECONFIG

kubectl wait --for=condition=Ready nodes --all --timeout=300s
kubectl get nodes -o wide
bad="$(kubectl get pods -A --no-headers | awk '$4!="Running" && $4!="Completed"')"
if [[ -n "$bad" ]]; then
  echo "Pods not healthy:"; echo "$bad"; exit 1
fi
echo "Cluster healthy"
