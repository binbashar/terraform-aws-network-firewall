output "id" {
  description = "The ID that identifies the firewall."
  value       = var.enabled && var.create_network_firewall ? aws_networkfirewall_firewall.firewall[0].id : null
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall."
  value       = var.enabled && var.create_network_firewall ? aws_networkfirewall_firewall.firewall[0].id : null
}

output "network_firewall_status" {
  description = "Nested list of information about the current status of the firewall."
  value       = var.enabled && var.create_network_firewall ? aws_networkfirewall_firewall.firewall[0].firewall_status : []
}
