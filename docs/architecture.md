# Architecture

```
vault ──► provision.sh ──► terraform (VMs) ──► gen-inventory ──► ansible (RKE2)
```

1. **Secrets**: Proxmox API token and RKE2 join token live in Vault KV and are
   exported as env vars only for the duration of the run.
2. **Terraform**: `proxmox-vm` module cloned per node via `for_each`; adding a
   node = bumping `agent_count`.
3. **Inventory**: generated from Terraform outputs so IaC is the single source of truth.
4. **Ansible**: `common` (swap, sysctl, time sync) -> `rke2_server` (serial) -> `rke2_agent`.
   RKE2 runs with the `cis` profile.

## Scaling
Increase `agent_count`, run `make up`. Only the new VM and node are touched.

## Not covered (by design, lab scope)
Remote Terraform state, Vault HA, VIP/kube-vip for the API endpoint.
