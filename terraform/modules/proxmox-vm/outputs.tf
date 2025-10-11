output "name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.this.vm_id
}

output "ipv4_address" {
  description = "Address without prefix length."
  value       = split("/", var.ipv4_cidr)[0]
}
