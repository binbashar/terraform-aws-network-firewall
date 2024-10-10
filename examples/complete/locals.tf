locals {
  
  home_net_cidr = ["10.10.0.0/16"]
  
  # Network Firewall
  managed_rule_groups = [
    {
      name         = "BotNetCommandAndControlDomainsStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/BotNetCommandAndControlDomainsStrictOrder"
      priority     = 10
    },
    {
      name         = "AbusedLegitBotNetCommandAndControlDomainsStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/AbusedLegitBotNetCommandAndControlDomainsStrictOrder"
      priority     = 11
    },
    {
      name         = "MalwareDomainsStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/MalwareDomainsStrictOrder"
      priority     = 12
    },
    {
      name         = "AbusedLegitMalwareDomainsStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/AbusedLegitMalwareDomainsStrictOrder"
      priority     = 13
    },
    {
      name         = "ThreatSignaturesDoSStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesDoSStrictOrder"
      action_mode  = "DROP_TO_ALERT"
      priority     = 14
    },
    {
      name         = "ThreatSignaturesSuspectStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesSuspectStrictOrder"
      action_mode  = "DROP_TO_ALERT"
      priority     = 15
    },
    {
      name         = "ThreatSignaturesExploitsStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesExploitsStrictOrder"
      action_mode  = "DROP_TO_ALERT"
      priority     = 16
    },
    {
      name         = "ThreatSignaturesScannersStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesScannersStrictOrder"
      action_mode  = "DROP_TO_ALERT"
      priority     = 17
    },
    {
      name         = "ThreatSignaturesIOCStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesIOCStrictOrder"
      action_mode  = "DROP_TO_ALERT"
      priority     = 18
    },
    {
      name         = "ThreatSignaturesWebAttacksStrictOrder"
      arn          = "arn:aws:network-firewall:us-east-1:aws-managed:stateful-rulegroup/ThreatSignaturesWebAttacksStrictOrder"
      action_mode  = "DROP_TO_ALERT"
      priority     = 19
    }
  ]

  suricata_rules = {
    stateful-group = {
      description  = "Suricata rule group"
      capacity     = 100
      priority     = 50
      rules_string = <<EOF
         # Silently allow TCP 3-way handshake to be setup by $HOME_NET clients
        pass tcp $HOME_NET any -> !$HOME_NET any (flow:not_established, to_server; msg:"pass rules do not alert/log"; sid:9918156;)
        pass tcp !$HOME_NET any -> !$HOME_NET any (flow:not_established, to_client; msg:"pass rules do not alert/log"; sid:9918199;)
        pass tcp $HOME_NET any -> $HOME_NET 443 (flow:to_server; msg:"Allow HTTPS traffic between internal VPCs"; sid:1000010; rev:1;)
        pass tcp $HOME_NET any -> $HOME_NET 80 (flow:to_server; msg:"Allow HTTP traffic between internal VPCs"; sid:1000011; rev:1;)
        pass tcp $HOME_NET any -> $HOME_NET 22 (flow:to_server; msg:"Allow SSH traffic between internal VPCs"; sid:1000012; rev:1;)
        pass tcp $HOME_NET any -> $HOME_NET 21 (flow:to_server; msg:"Allow FTP control traffic between internal VPCs"; sid:1000013; rev:1;)
        pass tcp $HOME_NET any -> $HOME_NET 20 (flow:to_server; msg:"Allow FTP data traffic between internal VPCs"; sid:1000014; rev:1;)
        pass udp $HOME_NET any -> $HOME_NET 53 (flow:to_server; msg:"Allow DNS traffic between internal VPCs"; sid:1000016; rev:1;)
        pass udp $HOME_NET 53 -> $HOME_NET any (flow:to_client; msg:"Allow inbound DNS traffic to internal networks"; sid:1000023; rev:1;)
        alert tcp $HOME_NET any -> $HOME_NET any (flow:to_server, established; msg:"Reject unapproved TCP traffic between internal VPCs"; sid:1000024; rev:1;)
        reject tcp $HOME_NET any -> $HOME_NET any (flow:to_server, established; msg:"Reject unapproved TCP traffic between internal VPCs"; sid:1000017; rev:1;)
        drop udp $HOME_NET any -> $HOME_NET any (flow:to_server; msg:"Drop unapproved UDP traffic between internal VPCs"; sid:1000018; rev:1;)
        pass tcp $HOME_NET any -> !$HOME_NET 443 (flow:to_server; msg:"Allow outbound HTTPS traffic to external networks"; sid:1000003; rev:1;)
        pass tcp $HOME_NET any -> !$HOME_NET 80 (flow:to_server; msg:"Allow outbound HTTP traffic to external networks"; sid:1000004; rev:1;)
        pass tcp $HOME_NET any -> !$HOME_NET 22 (flow:to_server; msg:"Allow outbound SSH traffic to external networks"; sid:1000005; rev:1;)
        pass tcp $HOME_NET any -> !$HOME_NET 21 (flow:to_server; msg:"Allow outbound FTP control traffic"; sid:1000006; rev:1;)
        pass tcp $HOME_NET any -> !$HOME_NET 20 (flow:to_server; msg:"Allow outbound FTP data traffic"; sid:1000007; rev:1;)
        pass udp $HOME_NET any -> !$HOME_NET 123 (flow:to_server; msg:"Allow outbound NTP traffic to external networks"; sid:1000008; rev:1;)
        pass udp !$HOME_NET 123 -> $HOME_NET any (flow:to_client; msg:"Allow inbound NTP traffic to internal networks"; sid:1000021; rev:1;)
        pass udp $HOME_NET any -> !$HOME_NET 53 (flow:to_server; msg:"Allow outbound DNS traffic to external networks"; sid:1000009; rev:1;)
        pass udp !$HOME_NET 53 -> $HOME_NET any (flow:to_client; msg:"Allow inbound DNS traffic to internal networks"; sid:1000022; rev:1;)
        alert tcp $HOME_NET any -> !$HOME_NET any (flow:to_server, established; msg:"Reject unapproved TCP traffic to external networks"; sid:9822312;)
        reject tcp $HOME_NET any -> !$HOME_NET any (flow:to_server, established; msg:"Reject unapproved TCP traffic to external networks"; sid:9822311;)
        drop udp $HOME_NET any -> !$HOME_NET any (flow:to_server; msg:"Drop unapproved UDP traffic to external networks"; sid:82319824;)
      EOF
    }
  }
  
  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
