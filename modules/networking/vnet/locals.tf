locals {
  # Azure Firewall and Application Gateway subnets cannot have NSGs associated with them,
  # and we only create/associate an NSG for a subnet when the caller has actually supplied
  # rules for it via nsg_rules. With nsg_rules = {} (the default), this creates zero NSGs
  # instead of an empty-but-present NSG per subnet.
  nsg_protected_subnets = {
    for k, v in var.subnets : k => v
    if !contains(["AzureFirewallSubnet", "AppGatewaySubnet"], k) && contains(keys(var.nsg_rules), k)
  }
}
