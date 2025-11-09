#!/usr/bin/env bash
# Render the Ansible inventory from Terraform outputs.
set -euo pipefail

ENV_DIR="${1:-terraform/environments/lab}"
OUT="${2:-ansible/inventory/hosts.ini}"
JSON="$(terraform -chdir="$ENV_DIR" output -json)"

{
  echo "[rke2_servers]"
  jq -r '.server_ips.value | to_entries[] | "\(.key) ansible_host=\(.value)"' <<<"$JSON"
  echo
  echo "[rke2_agents]"
  jq -r '.agent_ips.value | to_entries[] | "\(.key) ansible_host=\(.value)"' <<<"$JSON"
  echo
  echo "[rke2:children]"
  echo "rke2_servers"
  echo "rke2_agents"
  echo
  echo "[rke2:vars]"
  echo "ansible_user=ops"
} > "$OUT"
echo "Wrote $OUT"
