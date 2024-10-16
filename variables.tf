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
  default     = ["aws:aws:forward_to_sfe"]
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

# Stateful Suricata rules
variable "stateful_suricata_rule_groups" {
  description = "Optional stateful Suricata rule groups"
  type = map(object({
    description  = string
    capacity     = number
    rules_string = string
    priority     = number
  }))
  default = {}
}

# Tags
variable "tags" {
  description = "Map of resource tags to associate with the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "managed_rule_groups" {
  description = "List of managed rule groups with ARNs, priorities, and action modes"
  type = list(object({
    name        = string
    arn         = string
    action_mode = optional(string)
    priority    = string
  }))
  default = []
}

variable "rule_order" {
  description = "Define the rule evaluation order for stateful rule groups. Options: STRICT_ORDER, DEFAULT_ACTION_ORDER."
  type        = string
  default     = "DEFAULT_ACTION_ORDER"
}

variable "home_net_cidr" {
  description = "List of CIDR blocks for the internal network (HOME_NET)"
  type        = list(string)
  default     = []
}

variable "external_net_cidr" {
  description = "List of CIDR blocks for the externla network (EXTERNAL_NET)"
  type        = list(string)
  default     = []
}

variable "stream_exception_policy" {
  description = "Define the action to take on a packet that does not match any stateful rule group. Options: DROP, ALERT."
  type        = string
  default     = "DROP"
}

variable "enable_firewall_logs" {
  type    = bool
  default = false
  description = "Enable logging for the firewall"
}

variable "log_destination_type" {
  type    = string
  default = "CLOUDWATCHLOGS"
  description = "Log destination type. Options: CLOUDWATCHLOGS, S3, KinesisDataFirehose"
}

variable "log_type" {
  type    = list(string)
  default = ["FLOW", "ALERT"]
  description = "Log types to enable. Options: FLOW, ALERT"
}

variable "cloudwatch_log_group_name" {
  type    = string
  default = null
  description = "CloudWatch log group name"
}

variable "s3_bucket_name" {
  type    = string
  default = null
  description = "S3 bucket name"
}

variable "kinesis_stream_arn" {
  type    = string
  default = null
  description = "Amazon Resource Name (ARN) of the Kinesis Data Firehose stream"
}

variable "log_retention_in_days" {
  type    = number
  default = 90
  description = "The number of days to retain log events in the log group"
}
