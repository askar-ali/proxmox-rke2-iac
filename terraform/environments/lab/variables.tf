variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  description = "Format: user@realm!tokenid=secret. Supply via TF_VAR_ or Vault, never commit."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  type    = bool
  default = true
}

variable "node_name" {
  type    = string
  default = "pve1"
}

variable "template_vm_id" {
  type = number
}

variable "network_prefix" {
  description = "First three octets, e.g. 192.0.2"
  type        = string
  default     = "192.0.2"
}

variable "gateway" {
  type    = string
  default = "192.0.2.1"
}

variable "server_count" {
  description = "Control-plane nodes. Use an odd number for etcd quorum."
  type        = number
  default     = 3

  validation {
    condition     = var.server_count % 2 == 1
    error_message = "server_count must be odd (1, 3, 5) to keep etcd quorum."
  }
}

variable "agent_count" {
  type    = number
  default = 3
}

variable "ssh_public_keys" {
  type = list(string)
}
