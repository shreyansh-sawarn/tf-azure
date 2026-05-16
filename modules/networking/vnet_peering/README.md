# VNet Peering Module

This module establishes bidirectional peering between two Azure Virtual Networks.

## Features
- Bidirectional peering (Source to Target and Target to Source)
- Configurable forwarded traffic and gateway transit
- Ideal for Hub-Spoke architectures

## Usage

```hcl
module "vnet_peering" {
  source = "../vnet_peering"

  source_vnet_name           = "hub-vnet"
  source_vnet_id             = module.hub_vnet.vnet_id
  source_resource_group_name = "hub-rg"

  target_vnet_name           = "spoke-vnet"
  target_vnet_id             = module.spoke_vnet.vnet_id
  target_resource_group_name = "spoke-rg"
}
```
