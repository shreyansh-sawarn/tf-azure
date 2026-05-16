# Route Table Module

This module creates an Azure Route Table (UDR) and associates it with specified subnets.

## Features
- Dynamic route creation
- Multiple subnet associations
- Ideal for forced tunneling and hub-spoke traffic steering

## Usage

```hcl
module "route_table" {
  source = "../route_table"

  name                = "app-rt"
  location            = "eastus"
  resource_group_name = "network-rg"
  subnet_ids          = [module.vnet.subnet_ids["app"]]

  routes = [
    {
      name           = "to-firewall"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "VirtualAppliance"
      next_hop_ip    = "10.0.4.4"
    }
  ]
}
```
