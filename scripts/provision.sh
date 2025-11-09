#!/usr/bin/env bash
# One command: Vault secrets -> Terraform apply -> inventory -> Ansible.
# Idempotent: re-running changes nothing if the cluster already matches.
set -euo pipefail
cd "$(dirname "$0")/.."

ENV_DIR="terraform/environments/lab"
PLAN_ONLY=false
[[ "${1:-}" == "--plan" ]] && PLAN_ONLY=true

for bin in terraform ansible-playbook vault jq; do
  command -v "$bin" >/dev/null || { echo "missing dependency: $bin" >&2; exit 1; }
done

# shellcheck source=scripts/vault-env.sh
source scripts/vault-env.sh

terraform -chdir="$ENV_DIR" init -input=false
terraform -chdir="$ENV_DIR" plan -input=false -out=tfplan

if $PLAN_ONLY; then
  echo "Plan only; stopping."
  exit 0
fi

terraform -chdir="$ENV_DIR" apply -input=false tfplan
scripts/gen-inventory.sh "$ENV_DIR"

ansible-galaxy collection install -r ansible/requirements.yml
( cd ansible && ansible-playbook playbooks/site.yml )
