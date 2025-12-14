# Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `rke2-server` fails to start | Missing etcd user or CIS sysctls | Re-run the `rke2_server` role |
| Agent stuck "NotReady" | Port 9345/8472 blocked | Check `firewall_cluster_cidr` matches the node network |
| Terraform: clone timeout | Template not cloud-init ready / wrong VM ID | Verify `template_vm_id`, guest agent installed |
| Ansible assert "no join token" | `RKE2_TOKEN` not exported | `source scripts/vault-env.sh` |
| Locked out after hardening | SSH key not injected | Check `ssh_public_keys`; use Proxmox console |

Logs: `journalctl -u rke2-server -f` (servers), `-u rke2-agent -f` (agents).
