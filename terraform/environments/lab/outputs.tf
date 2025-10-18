output "server_ips" {
  value = { for k, m in module.server : k => m.ipv4_address }
}

output "agent_ips" {
  value = { for k, m in module.agent : k => m.ipv4_address }
}
