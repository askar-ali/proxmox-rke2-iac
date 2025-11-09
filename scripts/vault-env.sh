#!/usr/bin/env bash
# Source me: pulls secrets from Vault into env vars (nothing written to disk).
#   source scripts/vault-env.sh
set -euo pipefail

: "${VAULT_ADDR:?set VAULT_ADDR}"
vault token lookup >/dev/null 2>&1 || { echo "Not logged in: run 'vault login'" >&2; return 1 2>/dev/null || exit 1; }

TF_VAR_proxmox_api_token="$(vault kv get -field=api_token secret/proxmox/terraform)"
RKE2_TOKEN="$(vault kv get -field=token secret/rke2/cluster)"
export TF_VAR_proxmox_api_token RKE2_TOKEN
