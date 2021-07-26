variable "name" {
  type        = string
  description = "A friendly name of the firewall."
}

variable "description" {
  type        = string
  description = "A friendly description of the firewall."
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "The unique identifier of the VPC where AWS Network Firewall should create the firewall"
}

variable "delete_protection" {
  description = "A boolean flag indicating whether it is possible to delete the firewall."
  type        = bool
  default     = false
}

variable "firewall_policy_change_protection" {
  description = "A boolean flag indicating whether it is possible to change the associated firewall policy."
  type        = bool
  default     = false
}

variable "subnet_change_protection" {
  description = "A boolean flag indicating whether it is possible to change the associated subnet(s)."
  type        = bool
  default     = false
}

variable "enabled" {
  description = "Change to false to avoid deploying AWS Network Firewall resources."
  type        = bool
  default     = true
}

variable "create_network_firewall" {
  description = "Set to false if you just want to create the security policy, stateless and stateful rules"
  type        = bool
  default     = true
}

variable "subnet_mapping" {
  type        = map(any)
  description = "Subnets map. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet."
}

# firewall policy
variable "firewall_policy_name" {
  type        = string
  description = " A friendly name of the firewall policy."
  default     = null
}

# Stateless rule group
variable "stateless_rule_groups" {
  type        = any
  description = "Map of stateless rules groups."
  default     = {}
}

variable "stateless_default_actions" {
  description = "Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sf`e. In addition, you can specify custom actions that are compatible with your standard action choice. If you want non-matching packets to be forwarded for stateful inspection, specify `aws:forward_to_sfe`."
  type        = list(any)
  default     = ["aws:drop"]
}

variable "stateless_fragment_default_actions" {
  description = "Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sf`e. In addition, you can specify custom actions that are compatible with your standard action choice. If you want non-matching packets to be forwarded for stateful inspection, specify `aws:forward_to_sfe`."
  type        = list(any)
  default     = ["aws:drop"]
}

# Stateful rules
variable "stateful_rule_groups" {
  type        = any
  description = "Map of stateful rules groups."
  default     = {}
}

# Tags
variable "tags" {
  description = "Map of resource tags to associate with the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}
