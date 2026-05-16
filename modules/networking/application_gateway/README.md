# Application Gateway with WAF Module

This module provisions an Azure Application Gateway with Web Application Firewall (WAF) v2.

## Features
- Layer 7 load balancing
- WAF protection (OWASP ruleset)
- Managed Public IP
- Flexible backend pool and HTTP settings

## Usage

```hcl
module "app_gateway" {
  source = "../application_gateway"

  name                = "main-agw"
  location            = "eastus"
  resource_group_name = "network-rg"
  subnet_id           = module.vnet.subnet_ids["AppGatewaySubnet"]
  waf_enabled         = true
  waf_mode            = "Prevention"
}
```
