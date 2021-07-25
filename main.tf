# Firewall
resource "aws_networkfirewall_firewall" "firewall" {

  count = var.enabled ? 1 : 0

  name                              = var.name
  description                       = var.description
  delete_protection                 = var.delete_protection
  firewall_policy_change_protection = var.firewall_policy_change_protection
  subnet_change_protection          = var.subnet_change_protection
  firewall_policy_arn               = aws_networkfirewall_firewall_policy.policy[0].arn
  vpc_id                            = var.vpc_id

  # Subnets mapping
  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = var.tags
}

# Policy
resource "aws_networkfirewall_firewall_policy" "policy" {

  count = var.enabled ? 1 : 0

  name = var.firewall_policy_name == null ? "${var.name}-firewall-policy" : var.firewall_policy_name

  firewall_policy {
    stateless_default_actions          = var.stateless_default_actions
    stateless_fragment_default_actions = var.stateless_fragment_default_actions

    # Stateless rule group reference
    dynamic "stateless_rule_group_reference" {
      for_each = var.stateless_rule_groups
      content {
        priority     = lookup(stateless_rule_group_reference.value, "priority")
        resource_arn = aws_networkfirewall_rule_group.stateless_rule_group[stateless_rule_group_reference.key].arn
      }
    }

    # Stateful rule group reference
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_groups
      content {
        resource_arn = aws_networkfirewall_rule_group.staleful_rule_group[stateful_rule_group_reference.key].arn
      }
    }
  }

  tags = var.tags

  depends_on = [aws_networkfirewall_rule_group.stateless_rule_group]
}

# Stateless rule groups
resource "aws_networkfirewall_rule_group" "stateless_rule_group" {

  for_each = var.enabled ? var.stateless_rule_groups : {}

  name        = each.key
  description = lookup(each.value, "description")
  capacity    = lookup(each.value, "capacity", 100)
  type        = "STATELESS"

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {
        dynamic "stateless_rule" {
          for_each = lookup(each.value, "rules", [])
          content {
            priority = lookup(stateless_rule.value, "priority")
            rule_definition {
              actions = lookup(stateless_rule.value, "actions")
              match_attributes {
                protocols = lookup(stateless_rule.value, "protocols", null)
                # Source
                dynamic "source" {
                  for_each = lookup(stateless_rule.value, "source", null) == null ? [] : [lookup(stateless_rule.value, "source")]
                  content {
                    address_definition = lookup(source.value, "address")
                  }
                }
                dynamic "source_port" {
                  for_each = lookup(stateless_rule.value, "source_port", null) == null ? [] : [lookup(stateless_rule.value, "source_port")]
                  content {
                    from_port = lookup(source_port.value, "from_port", null)
                    to_port   = lookup(source_port.value, "to_port", null)
                  }
                }
                # Destination
                dynamic "destination" {
                  for_each = lookup(stateless_rule.value, "destination", null) == null ? [] : [lookup(stateless_rule.value, "destination")]
                  content {
                    address_definition = lookup(destination.value, "address")
                  }
                }
                dynamic "destination_port" {
                  for_each = lookup(stateless_rule.value, "destination_port", null) == null ? [] : [lookup(stateless_rule.value, "destination_port")]
                  content {
                    from_port = lookup(destination_port.value, "from_port", null)
                    to_port   = lookup(destination_port.value, "to_port", null)
                  }
                }
                # TCP flag
                dynamic "tcp_flag" {
                  for_each = lookup(stateless_rule.value, "tcp_flag", null) == null ? [] : [lookup(stateless_rule.value, "tcp_flag")]
                  content {
                    flags = lookup(tcp_flag.value, "flags", null)
                    masks = lookup(tcp_flag.value, "masks", null)
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  tags = var.tags
}

# Stateful rule groups
resource "aws_networkfirewall_rule_group" "staleful_rule_group" {

  for_each = var.enabled ? var.stateful_rule_groups : {}

  name        = each.key
  description = lookup(each.value, "description")
  capacity    = lookup(each.value, "capacity", 100)
  type        = "STATEFUL"
  rule_group {
    # rule variables
    dynamic "rule_variables" {
      for_each = [lookup(each.value, "rule_variables", {})]
      content {
        # IP Sets
        dynamic "ip_sets" {
          for_each = lookup(rule_variables.value, "ip_sets", null) == null ? {} : lookup(rule_variables.value, "ip_sets")
          content {
            key = ip_sets.key
            ip_set {
              definition = ip_sets.value
            }
          }
        }
        # Port Sets
        dynamic "port_sets" {
          for_each = lookup(rule_variables.value, "port_sets", null) == null ? {} : lookup(rule_variables.value, "port_sets")
          content {
            key = port_sets.key
            port_set {
              definition = port_sets.value
            }
          }
        }
      }
    }
    rules_source {
      dynamic "rules_source_list" {
        for_each = lookup(each.value, "rules_source_list", null) == null ? [] : [lookup(each.value, "rules_source_list")]
        content {
          generated_rules_type = lookup(rules_source_list.value, "generated_rules_type")
          target_types         = lookup(rules_source_list.value, "target_types")
          targets              = lookup(rules_source_list.value, "targets")
        }
      }
    }
  }

  tags = var.tags
}

