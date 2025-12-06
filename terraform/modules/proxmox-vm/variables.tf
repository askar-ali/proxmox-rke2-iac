variable "name" {
  description = "VM name (also used as hostname)."
  type        = string
}

variable "node_name" {
  description = "Proxmox node to place the VM on."
  type        = string
}

variable "template_vm_id" {
  description = "VM ID of the cloud-init template to clone."
  type        = number
}

variable "vm_id" {
  description = "Explicit VM ID. Null lets Proxmox choose."
  type        = number
  default     = null
}

variable "cores" {
  type    = number
  default = 2

  validation {
    condition     = var.cores >= 1 && var.cores <= 64
    error_message = "cores must be between 1 and 64."
  }
}

variable "memory_mb" {
  type    = number
  default = 4096

  validation {
    condition     = var.memory_mb >= 2048
    error_message = "RKE2 nodes need at least 2048 MB of memory."
  }
}

variable "disk_gb" {
  type    = number
  default = 40
}

variable "datastore_id" {
  type    = string
  default = "local-lvm"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ipv4_cidr" {
  description = "Static address in CIDR form, e.g. 192.0.2.10/24."
  type        = string

  validation {
    condition     = can(cidrhost(var.ipv4_cidr, 0))
    error_message = "ipv4_cidr must be a valid CIDR such as 192.0.2.10/24."
  }
}

variable "gateway" {
  type = string
}

variable "dns_servers" {
  type    = list(string)
  default = ["1.1.1.1"]
}

variable "ssh_public_keys" {
  description = "Public keys injected via cloud-init."
  type        = list(string)
}

variable "ci_user" {
  type    = string
  default = "ops"
}

variable "tags" {
  type    = list(string)
  default = []
}
