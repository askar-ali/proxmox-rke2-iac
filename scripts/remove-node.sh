#!/usr/bin/env bash
# Safely remove an agent: cordon, drain, delete the node object, then shrink Terraform.
# Usage: remove-node.sh <node-name> <new-agent-count>
set -euo pipefail
cd "$(dirname "$0")/.."

NODE="${1:?node name}"
COUNT="${2:?new agent count}"
KUBECONFIG="${KUBECONFIG:-$(ls kubeconfig-*.yaml | head -1)}"
export KUBECONFIG

kubectl drain "$NODE" --ignore-daemonsets --delete-emptydir-data --timeout=300s
kubectl delete node "$NODE"

source scripts/vault-env.sh
terraform -chdir=terraform/environments/lab apply -input=false -var "agent_count=${COUNT}"
