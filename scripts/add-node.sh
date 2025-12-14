#!/usr/bin/env bash
# Add one agent: bump agent_count, apply, then run Ansible limited to the new host.
# Usage: add-node.sh <new-agent-count>
set -euo pipefail
cd "$(dirname "$0")/.."

COUNT="${1:?new agent count}"
ENV_DIR="terraform/environments/lab"

source scripts/vault-env.sh
terraform -chdir="$ENV_DIR" apply -input=false -var "agent_count=${COUNT}"
scripts/gen-inventory.sh "$ENV_DIR"
( cd ansible && ansible-playbook playbooks/site.yml --limit "rke2-agent-${COUNT}" )
