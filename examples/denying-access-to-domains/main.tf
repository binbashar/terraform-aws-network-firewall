module "firewall" {

  source = "github.com/binbashar/terraform-aws-network-firewall.git"

  name        = "firewall"
  description = "AWS Network Firewall example"

  vpc_id         = data.terraform_remote_state.inspection_vpc.outputs.vpc_id
  subnet_mapping = data.terraform_remote_state.inspection_vpc.outputs.inspection_subnets

  # Stateless rule groups
  stateless_rule_groups = {
    stateless-group-1 = {
      description = "Stateless rules"
      priority    = 1
      capacity    = 100
      # stateless-group-1 rules
      rules = [
        {
          priority  = 2
          actions   = ["aws:drop"]
          protocols = [1]
          source = {
            address = "0.0.0.0/0"
          }
          destination = {
            address = "0.0.0.0/0"
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
    stateful-group-1 = {
      description = "Stateful Inspection for denying access to domains"
      capacity    = 100
      #rule_variables = {}
      rules_source_list = {
        generated_rules_type = "DENYLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = [".bad-omain.org", ".evil-domain.com"]
      }
    }
  }
}

