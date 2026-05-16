module "vnet" {
  source = "../../../modules/networking/vnet"

  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnets             = var.subnets
  nsg_rules           = var.nsg_rules
  tags                = var.tags
}

# The actual module for firewall is in modules/networking/firewall
# For a grouped stack, we'd call it here. 
# Since we are refactoring existing structure, I will assume modules/networking/firewall exists or is a placeholder.
module "firewall" {
  source = "../../../modules/networking/firewall"

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.firewall_name
  subnet_id           = module.vnet.subnet_ids["AzureFirewallSubnet"]
  sku_name            = var.firewall_sku_name
  sku_tier            = var.firewall_sku_tier
  tags                = var.tags
}

module "route_table" {
  source = "../../../modules/networking/route_table"

  name                = "${var.vnet_name}-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_ids          = [module.vnet.subnet_ids["app"], module.vnet.subnet_ids["db"]]

  routes = [
    {
      name           = "route-to-firewall"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "VirtualAppliance"
      next_hop_ip    = module.firewall.private_ip
    }
  ]
  tags = var.tags
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "subnet_ids" {
  value = module.vnet.subnet_ids
}

output "vnet_name" {
  value = module.vnet.vnet_name
}
