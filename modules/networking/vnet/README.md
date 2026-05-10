# VNET Module

Provisions an Azure Virtual Network with configurable subnets, Network Security Groups with per-subnet rules, and NSG-to-subnet associations. Includes a dedicated `AzureFirewallSubnet` by default.

## Usage

```hcl
module "vnet" {
  source              = "../../../modules/networking/vnet"
  resource_group_name = "my-rg"
  location            = "East US"
  vnet_name           = "my-vnet"

  subnets = {
    web                 = { address_prefixes = ["10.0.1.0/24"] }
    app                 = { address_prefixes = ["10.0.2.0/24"] }
    db                  = { address_prefixes = ["10.0.3.0/24"] }
    AzureFirewallSubnet = { address_prefixes = ["10.0.4.0/24"] }
  }
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `vnet_name` | `string` | — | Name of the Virtual Network |
| `address_space` | `list(string)` | `["10.0.0.0/16"]` | CIDR blocks for the VNET |
| `subnets` | `map(object)` | web/app/db/AzureFirewallSubnet | Subnet definitions |
| `nsg_rules` | `map(list(object))` | Per-subnet security rules | NSG rules per subnet |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `vnet_id` | The ID of the Virtual Network |
| `vnet_name` | The name of the Virtual Network |
| `subnet_ids` | Map of subnet name → subnet ID |
