module "firewall" {

  source = "../../"

  name                              = "firewall"
  description                       = "AWS Network Firewall example"
  delete_protection                 = false
  firewall_policy_change_protection = false
  subnet_change_protection          = false

  # VPC
  vpc_id         = data.terraform_remote_state.inspection_vpc.outputs.vpc_id
  subnet_mapping = data.terraform_remote_state.inspection_vpc.outputs.inspection_subnets

  # Stateless rule groups
  stateless_rule_groups = {
    stalteess-group-1 = {
      description = "Stateless rules"
      priority    = 1
      capacity    = 100
      # stateless-group-1 rules
      rules = [
        {
          priority  = 1
          protocols = [6, 1, 17]
          actions   = ["aws:drop"]
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
          priority = 10
          actions  = ["aws:forward_to_sfe"]
          source = {
            address = "0.0.0.0/0"
          }
          destination = {
            address = "0.0.0.0/0"
          }
        }
      ]
    }
  }

  # Stateful rules
  stateful_rule_groups = {
    stateful-group-1 = {
      description = "Stateful Inspection for denying access to a domain"
      capacity    = 100
      rules_source_list = [
        {
          generated_rules_type = "DENYLIST"
          target_types         = ["TLS_SNI", "HTTP_HOST"]
          targets              = [".wikipedia.org"]
        }
      ]
    }
  }
}

