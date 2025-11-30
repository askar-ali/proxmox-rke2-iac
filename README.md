# proxmox-rke2-iac

Provision a Kubernetes (RKE2) cluster on a Proxmox VM fleet using Terraform,
Ansible and Bash, with HashiCorp Vault for secrets.

> Lab recreation of the infrastructure-as-code patterns I use in production
> (since 10/2025). Built generically: all hostnames, IPs and credentials are
> placeholders.

## Why this stack

| Tool | Job | Why |
|------|-----|-----|
| Terraform | Create/destroy VMs on Proxmox | Declarative, reviewable plans, reusable module |
| Ansible | Configure OS + install RKE2 | Agentless, idempotent roles |
| Vault | Store Proxmox API token and RKE2 join token | No secrets in Git or tfvars |
| Bash | Glue (`scripts/provision.sh`) | One command from nothing to a joined node |

Manual node build (clone VM, set IP, SSH, install, join) is repetitive and
error-prone. This pipeline makes it one idempotent command.

## Layout

```
terraform/modules/proxmox-vm   reusable VM module
terraform/environments/lab     example environment (N servers + N agents)
ansible/                       roles: common, rke2_server, rke2_agent
scripts/                       vault-env, gen-inventory, provision
docs/architecture.md           design notes
```

## Prerequisites

- Proxmox VE with an API token (role allowing VM clone/config).
- An Ubuntu cloud-init template VM (default ID `9000`).
- Vault with two KV v2 secrets:
  - `secret/proxmox/terraform` -> field `api_token`
  - `secret/rke2/cluster` -> field `token` (any long random string)
- Locally: `terraform >= 1.6`, `ansible`, `vault`, `jq`.

## Usage

```bash
cp terraform/environments/lab/terraform.tfvars.example terraform/environments/lab/terraform.tfvars
export VAULT_ADDR=https://vault.example.internal:8200 && vault login
make plan     # terraform plan only
make up       # terraform apply -> inventory -> ansible
make destroy  # tear the VMs down
```

The kubeconfig is fetched to the repo root as `kubeconfig-<vip>.yaml` (git-ignored).

## Scaling

Raise `agent_count` in tfvars and run `make up`; only the new node is created and joined.

## Status

Validated with `terraform validate`, `ansible-playbook --syntax-check` and CI
lint. Not run against a live cluster in this repo (lab only). See `CHANGELOG.md`.
