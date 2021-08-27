<div align="center">
    <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-ec2-basic-layout/master/figures/binbash-logo.png"
     alt="binbash" width="250"/>
</div>
<div align="right">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-network-firewall/master/figures/binbash-leverage-terraform-logo.png"
  alt="leverage" width="130"/>
</div>

# terraform-aws-network-firewall

## Overview

This mdule creates AWS Network firewall resources, which includes:
* Network Firewall
* Network Firewall Policy
* Network Firewall Stateless groups and rules
* Network Firewall Stateful groups and rules

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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_network_firewall"></a> [create\_network\_firewall](#input\_create\_network\_firewall) | Set to false if you just want to create the security policy, stateless and stateful rules | `bool` | `true` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | A boolean flag indicating whether it is possible to delete the firewall. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | A friendly description of the firewall. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Change to false to avoid deploying AWS Network Firewall resources. | `bool` | `true` | no |
| <a name="input_firewall_policy_change_protection"></a> [firewall\_policy\_change\_protection](#input\_firewall\_policy\_change\_protection) | A boolean flag indicating whether it is possible to change the associated firewall policy. | `bool` | `false` | no |
| <a name="input_firewall_policy_name"></a> [firewall\_policy\_name](#input\_firewall\_policy\_name) | A friendly name of the firewall policy. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A friendly name of the firewall. | `string` | n/a | yes |
| <a name="input_stateful_rule_groups"></a> [stateful\_rule\_groups](#input\_stateful\_rule\_groups) | Map of stateful rules groups. | `any` | `{}` | no |
| <a name="input_stateless_default_actions"></a> [stateless\_default\_actions](#input\_stateless\_default\_actions) | Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sf`e. In addition, you can specify custom actions that are compatible with your standard action choice. If you want non-matching packets to be forwarded for stateful inspection, specify `aws:forward_to_sfe`. | `list(any)` | <pre>[<br>  "aws:drop"<br>]</pre> | no |
| <a name="input_stateless_fragment_default_actions"></a> [stateless\_fragment\_default\_actions](#input\_stateless\_fragment\_default\_actions) | Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sf`e. In addition, you can specify custom actions that are compatible with your standard action choice. If you want non-matching packets to be forwarded for stateful inspection, specify `aws:forward_to_sfe`. | `list(any)` | <pre>[<br>  "aws:drop"<br>]</pre> | no |
| <a name="input_stateless_rule_groups"></a> [stateless\_rule\_groups](#input\_stateless\_rule\_groups) | Map of stateless rules groups. | `any` | `{}` | no |
| <a name="input_subnet_change_protection"></a> [subnet\_change\_protection](#input\_subnet\_change\_protection) | A boolean flag indicating whether it is possible to change the associated subnet(s). | `bool` | `false` | no |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | Subnets map. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet. | `map(any)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of resource tags to associate with the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The unique identifier of the VPC where AWS Network Firewall should create the firewall | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) that identifies the firewall. |
| <a name="output_id"></a> [id](#output\_id) | The ID that identifies the firewall. |
| <a name="output_network_firewall_stateful_group"></a> [network\_firewall\_stateful\_group](#output\_network\_firewall\_stateful\_group) | Map of stateful group rules |
| <a name="output_network_firewall_stateless_group"></a> [network\_firewall\_stateless\_group](#output\_network\_firewall\_stateless\_group) | Map of stateless group rules |
| <a name="output_network_firewall_status"></a> [network\_firewall\_status](#output\_network\_firewall\_status) | Nested list of information about the current status of the firewall. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
