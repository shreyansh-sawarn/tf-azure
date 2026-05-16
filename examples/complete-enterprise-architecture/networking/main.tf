module "vnet" {
  source = "../../../modules/networking/vnet"

  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnets             = var.subnets
  
  # Allow HTTP traffic for the demo webpage
  nsg_rules = {
    compute = [
      {
        name                       = "AllowHTTPInbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  tags = var.tags
}

output "subnet_ids" {
  value = module.vnet.subnet_ids
}

output "vnet_id" {
  value = module.vnet.vnet_id
}
