# proxmox-rke2-iac

Provision a Kubernetes (RKE2) cluster on a Proxmox VM fleet using Terraform,
Ansible and Bash, with HashiCorp Vault for secrets.

> Lab/portfolio project. All hostnames, IPs and credentials are placeholders.

## Why this stack

| Tool | Job | Why |
|------|-----|-----|
| Terraform | Create/destroy VMs on Proxmox | Declarative, reviewable plans, reusable module |
| Ansible | Configure OS + install RKE2 | Agentless, idempotent roles |
| Vault | Store Proxmox API token and RKE2 join token | No secrets in Git or tfvars |
| Bash | Glue (`scripts/provision.sh`) | One command from nothing to a joined node |

Manual node build (clone VM, set IP, SSH, install, join) is repetitive and
error-prone. This pipeline makes it one idempotent command per node.

## Layout

```
terraform/modules/proxmox-vm   reusable VM module
terraform/environments/lab     example environment (3 servers + N agents)
ansible/                       roles: common, rke2_server, rke2_agent
scripts/                       provisioning glue
docs/architecture.md           design notes
```

## Status

See `CHANGELOG.md`.
