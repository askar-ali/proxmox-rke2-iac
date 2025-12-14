# Runbook

## Add a worker
`scripts/add-node.sh <new-count>` - applies Terraform, regenerates inventory, runs Ansible only on the new host.

## Remove a worker
`scripts/remove-node.sh <node> <new-count>` - drains first so workloads reschedule, then deletes the VM.

## Rotate the join token
Update `secret/rke2/cluster` in Vault, then re-run `make up`. Running nodes keep working;
new nodes use the new token.

## etcd restore
Snapshots run every 6h (14 kept) at `/var/lib/rancher/rke2/server/db/snapshots`.
```
systemctl stop rke2-server
rke2 server --cluster-reset --cluster-reset-restore-path=<snapshot>
systemctl start rke2-server
```
Other servers must be wiped and rejoined afterwards.
