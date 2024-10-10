<a href="https://github.com/binbashar">
    <img src="https://raw.githubusercontent.com/binbashar/le-ref-architecture-doc/master/docs/assets/images/logos/binbash-leverage-banner.png" width="1032" align="left" alt="Binbash"/>
</a>
<br clear="left"/>

# terraform-aws-network-firewall

## Overview

This mdule creates AWS Network firewall resources, which includes:
* Network Firewall
* Network Firewall Policy
* Network Firewall Stateless groups and rules
* Network Firewall Stateful groups and rules
* Use custom Suricata Rules
* Use Managed Rules
* Use “Strict, Drop Established” rule order
* Use stateful rules instead of stateless rules
* Use $HOME_NET


## Example
**Deny domain access**
```
module "firewall" {

  source = "github.com/binbashar/terraform-aws-network-firewall.git"

  name        = "firewall"
  description = "AWS Network Firewall example"
  vpc_id      = "vpc-12345678910111213"

  subnet_mapping = {
    us-east-1a = "subnet-23456780101112131"
    us-east-1b = "subnet-13121110987654321"
  }

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
```

You can check the [complete example](examples/complete/) for other usages.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_networkfirewall_firewall.firewall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_firewall_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_rule_group.stateful_rule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.stateless_rule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_network_firewall"></a> [create\_network\_firewall](#input\_create\_network\_firewall) | Set to false if you just want to create the security policy, stateless and stateful rules | `bool` | `true` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete_protection) | A boolean flag indicating whether it is possible to delete the firewall. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | A friendly description of the firewall. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Change to false to avoid deploying AWS Network Firewall resources. | `bool` | `true` | no |
| <a name="input_firewall_policy_change_protection"></a> [firewall\_policy\_change\_protection](#input\_firewall\_policy\_change_protection) | A boolean flag indicating whether it is possible to change the associated firewall policy. | `bool` | `false` | no |
| <a name="input_firewall_policy_name"></a> [firewall\_policy_name](#input\_firewall\_policy_name) | A friendly name of the firewall policy. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A friendly name of the firewall. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The unique identifier of the VPC where AWS Network Firewall should create the firewall. | `string` | n/a | yes |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | Subnets map. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet. | `map(any)` | n/a | yes |
| <a name="input_stateless_default_actions"></a> [stateless\_default\_actions](#input\_stateless\_default\_actions) | Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sf`. | `list(any)` | `["aws:drop"]` | no |
| <a name="input_stateless_fragment_default_actions"></a> [stateless\_fragment\_default_actions](#input\_stateless\_fragment\_default_actions) | Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. | `list(any)` | `["aws:drop"]` | no |
| <a name="input_stateless_rule_groups"></a> [stateless\_rule\_groups](#input\_stateless\_rule\_groups) | Map of stateless rules groups, including custom actions. | `any` | `{}` | no |
| <a name="input_stateful_rule_groups"></a> [stateful\_rule\_groups](#input\_stateful\_rule\_groups) | Map of stateful rules groups, including Suricata and AWS Managed Rules. | `any` | `{}` | no |
| <a name="input_stateful_suricata_rule_groups"></a> [stateful\_suricata_rule_groups](#input\_stateful\_suricata\_rule\_groups) | Map of custom Suricata rules for stateful inspection. | `any` | `{}` | no |
| <a name="input_managed_rule_groups"></a> [managed\_rule\_groups](#input\_managed\_rule\_groups) | Map of AWS Managed Rule Groups for stateful inspection. | `any` | `{}` | no |
| <a name="input_rule_order"></a> [rule\_order](#input\_rule\_order) | The order in which stateless rules are evaluated: `STRICT_ORDER` or `DEFAULT_ACTION_ORDER`. | `string` | `"DEFAULT_ACTION_ORDER"` | no |
| <a name="input_stream_exception_policy"></a> [stream\_exception\_policy](#input\_stream_exception\_policy) | Policy for handling stream exceptions: `DROP`, `CONTINUE`, or `REJECT`. | `string` | `"DROP"` | no |
| <a name="input_home_net_cidr"></a> [home\_net\_cidr](#input\_home\_net\_cidr) | CIDR block to define the home network for the firewall rules. | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) that identifies the firewall. |
| <a name="output_id"></a> [id](#output\_id) | The ID that identifies the firewall. |
| <a name="output_network_firewall_policy"></a> [network\_firewall\_policy](#output\_network\_firewall\_policy) | The Firewall Network policy created. |
| <a name="output_network_firewall_stateful_group"></a> [network\_firewall\_stateful\_group](#output\_network\_firewall\_stateful\_group) | Map of stateful group rules. |
| <a name="output_network_firewall_stateless_group"></a> [network\_firewall\_stateless\_group](#output\_network\_firewall\_stateless\_group) | Map of stateless group rules. |
| <a name="output_network_firewall_status"></a> [network\_firewall\_status](#output\_network\_firewall\_status) | Nested list of information about the current status of the firewall. |
| <a name="output_network_firewall_suricata_rule_groups"></a> [network\_firewall\_suricata\_rule\_groups](#output\_network\_firewall\_suricata\_rule\_groups) | Map of Suricata rule groups for stateful inspection. |
| <a name="output_network_firewall_managed_rule_groups"></a> [network\_firewall\_managed\_rule\_groups](#output\_network\_firewall\_managed\_rule\_groups) | Map of AWS Managed Rule Groups for stateful inspection. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
