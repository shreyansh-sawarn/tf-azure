# Load Balancer Module

Provisions an Azure Load Balancer (Public or Internal) with health probes and load balancing rules.

## Features
- Standard SKU for zone redundancy
- Supports Public and Internal types
- Automated backend address pool and probe creation
- Customizable frontend and backend ports

## Usage

```hcl
module "lb" {
  source = "../load_balancer"

  name                = "app-lb"
  location            = "eastus"
  resource_group_name = "network-rg"
  type                = "Internal"
  subnet_id           = module.vnet.subnet_ids["app"]
}
```
