# Network Firewall
output "network_firewall_stateless_group" {
  description = "Map of stateless group rules"
  value = { for k, v in module.firewall.network_firewall_stateless_group :
    #k => "${v["capacity"]}"
    k => v["capacity"]
  }
}

output "network_firewall_stateful_group" {
  description = "Map of stateful group rules"
  value = { for k, v in module.firewall.network_firewall_stateful_group :
    k => v["description"]
  }
}

output "network_firewall_status" {
  description = "Nested list of information about the current status of the firewall."
  value = { for k, v in module.firewall.network_firewall_status :
    k => v
  }
}

output "num_network_firewall_azs" {
  description = "Number of AZs where the Network Firewall was deployed"
  value       = length(module.firewall.network_firewall_status[0]["sync_states"].*.availability_zone)
}

