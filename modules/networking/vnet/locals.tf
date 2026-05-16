locals {
  # Azure Firewall and Application Gateway subnets cannot have NSGs associated with them
  nsg_protected_subnets = { for k, v in var.subnets : k => v if !contains(["AzureFirewallSubnet", "AppGatewaySubnet"], k) }
}
