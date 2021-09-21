output "id" {
  description = "The ID that identifies the firewall."
  value       = var.enabled && var.create_network_firewall ? aws_networkfirewall_firewall.firewall[0].id : null
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall."
  value       = var.enabled && var.create_network_firewall ? aws_networkfirewall_firewall.firewall[0].id : null
}

output "network_firewall_policy" {
  description = "The Firewall Network policy created"
  value       = var.enabled ? aws_networkfirewall_firewall_policy.policy : null

}

output "network_firewall_status" {
  description = "Nested list of information about the current status of the firewall."
  value       = var.enabled && var.create_network_firewall ? aws_networkfirewall_firewall.firewall[0].firewall_status : []
}

output "network_firewall_stateless_group" {
  description = "Map of stateless group rules"
  value       = var.enabled ? aws_networkfirewall_rule_group.stateless_rule_group : null
}

output "network_firewall_stateful_group" {
  description = "Map of stateful group rules"
  value       = var.enabled ? aws_networkfirewall_rule_group.stateful_rule_group : null
}
