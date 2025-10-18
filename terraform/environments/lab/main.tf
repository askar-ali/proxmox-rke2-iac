provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}

locals {
  servers = { for i in range(var.server_count) : "rke2-server-${i + 1}" => 10 + i }
  agents  = { for i in range(var.agent_count) : "rke2-agent-${i + 1}" => 20 + i }
}

module "server" {
  source   = "../../modules/proxmox-vm"
  for_each = local.servers

  name            = each.key
  node_name       = var.node_name
  template_vm_id  = var.template_vm_id
  cores           = 2
  memory_mb       = 4096
  ipv4_cidr       = "${var.network_prefix}.${each.value}/24"
  gateway         = var.gateway
  ssh_public_keys = var.ssh_public_keys
  tags            = ["rke2", "server"]
}

module "agent" {
  source   = "../../modules/proxmox-vm"
  for_each = local.agents

  name            = each.key
  node_name       = var.node_name
  template_vm_id  = var.template_vm_id
  cores           = 4
  memory_mb       = 8192
  disk_gb         = 80
  ipv4_cidr       = "${var.network_prefix}.${each.value}/24"
  gateway         = var.gateway
  ssh_public_keys = var.ssh_public_keys
  tags            = ["rke2", "agent"]
}
