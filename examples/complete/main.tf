module "firewall" {

  source = "../../"

  enabled                 = true
  create_network_firewall = true # Set to false if you just want to create the security policy, stateless and stateful rules

  name                              = "firewall-example"
  description                       = "AWS Network Firewall example"
  delete_protection                 = false
  firewall_policy_name              = "firewall-policy-example"
  firewall_policy_change_protection = false
  subnet_change_protection          = false


  # VPC
  vpc_id         = data.terraform_remote_state.inspection_vpc.outputs.vpc_id
  subnet_mapping = data.terraform_remote_state.inspection_vpc.outputs.inspection_subnets

  # Stateless rule groups
  stateless_rule_groups = {
    stateless-group-example-1 = {
      description = "Stateless rules"
      priority    = 1
      capacity    = 100
      # stateless-group-1 rules
      custom_actions = {
        # action_name = dimension_value
        ExampleMetricsAction1 = 2
        ExampleMetricsAction2 = 4
      }
      rules = [
        {
          priority  = 1
          actions   = ["aws:drop"]
          protocols = [6, 17]
          source = {
            address = "10.0.0.0/16"
          }
          source_port = {
            from_port = 23
            to_port   = 23
          }
          destination = {
            address = "20.0.0.0/16"
          }
          destination_port = {
            from_port = 23
            to_port   = 23
          }
        },
        {
          priority  = 2
          actions   = ["aws:drop", "ExampleMetricsAction1"]
          protocols = [1]
          source = {
            address = "0.0.0.0/0"
          }
          destination = {
            address = "0.0.0.0/0"
          }
        },
        {
          priority  = 3
          actions   = ["aws:pass", "ExampleMetricsAction2"]
          protocols = [6, 17]
          source = {
            address = "1.2.3.4/32"
          }
          source_port = {
            from_port = 443
            to_port   = 443
          }
          destination = {
            address = "124.1.1.5/32"
          }
          destination_port = {
            from_port = 443
            to_port   = 443
          }
        },
        {
          priority = 10
          actions  = ["aws:forward_to_sfe"]
          source = {
            address = "0.0.0.0/0"
          }
          destination = {
            address = "0.0.0.0/0"
          }
        },
      ]
    }
  }

  # Stateful rules
  stateful_rule_groups = {
    # rules_source_list examples
    stateful-group-example-1 = {
      description = "Stateful Inspection for denying access to domains"
      capacity    = 100
      #rule_variables = {}
      rules_source_list = {
        generated_rules_type = "DENYLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = [".archive.org", ".badsite.com"]
      }
    }
    stateful-group-example-2 = {
      description = "Stateful Inspection for allowing access to domains"
      capacity    = 100
      rule_variables = {
        ip_sets = {
          HOME_NET     = ["10.0.0.0/16", "10.1.0.0/16", "192.0.2.0/24"]
          EXTERNAL_NET = ["20.0.0.0/16", "20.1.0.0/16", "192.0.3.0/24"]
          HTTP_SERVERS = ["10.2.0.0/24", "10.1.0.0/24"]
        }
        port_sets = {
          HTTP_PORTS = ["82", "8080"]
        }
      }
      rules_source_list = {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = [".wikipedia.org"]
      }
    }
    # stateful_rule examples
    stateful-group-example-3 = {
      description = "Permits http traffic from source"
      capacity    = 50
      stateful_rule = {
        action = "DROP"
        header = {
          destination      = "124.1.1.24/32"
          destination_port = 53
          direction        = "ANY"
          protocol         = "TCP"
          source           = "1.2.3.4/32"
          source_port      = 53
        }
        rule_option = {
          keyword = "sid:1"
        }
      }
    }
  }
}
