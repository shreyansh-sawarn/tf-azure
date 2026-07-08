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

By default, no NSGs are created — this module does not ship a permissive network default. To attach per-subnet Network Security Groups, pass `nsg_rules` explicitly. Reference 3-tier (web/app/db) pattern, including an explicit deny-all baseline per subnet:

```hcl
  nsg_rules = {
    web = [
      { name = "AllowHTTPS", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "*", destination_address_prefix = "*" },
      { name = "AllowHTTP", priority = 110, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "80", source_address_prefix = "*", destination_address_prefix = "*" },
      { name = "DenyAllInbound", priority = 4096, direction = "Inbound", access = "Deny", protocol = "*", source_port_range = "*", destination_port_range = "*", source_address_prefix = "*", destination_address_prefix = "*" },
    ]
    app = [
      { name = "AllowFromWebSubnet", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "8080", source_address_prefix = "10.0.1.0/24", destination_address_prefix = "*" },
      { name = "DenyAllInbound", priority = 4096, direction = "Inbound", access = "Deny", protocol = "*", source_port_range = "*", destination_port_range = "*", source_address_prefix = "*", destination_address_prefix = "*" },
    ]
    db = [
      { name = "AllowSQLFromAppSubnet", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "1433", source_address_prefix = "10.0.2.0/24", destination_address_prefix = "*" },
      { name = "DenyAllInbound", priority = 4096, direction = "Inbound", access = "Deny", protocol = "*", source_port_range = "*", destination_port_range = "*", source_address_prefix = "*", destination_address_prefix = "*" },
    ]
  }
```

Note the `web` tier above intentionally opens 80/443 to the internet — that's only appropriate for a genuinely public-facing tier. Scope `source_address_prefix` down for anything not meant to be internet-facing.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `vnet_name` | `string` | — | Name of the Virtual Network |
| `address_space` | `list(string)` | `["10.0.0.0/16"]` | CIDR blocks for the VNET |
| `subnets` | `map(object)` | web/app/db/AzureFirewallSubnet | Subnet definitions |
| `nsg_rules` | `map(list(object))` | `{}` (no NSGs created) | NSG rules per subnet |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `vnet_id` | The ID of the Virtual Network |
| `vnet_name` | The name of the Virtual Network |
| `subnet_ids` | Map of subnet name → subnet ID |
