# Azure Firewall Module

Provisions an Azure Firewall with a Standard SKU public IP and VNET-based configuration. Must be deployed to a subnet named `AzureFirewallSubnet`.

## Usage

```hcl
module "firewall" {
  source              = "../../../modules/networking/firewall"
  name                = "my-firewall"
  resource_group_name = "my-rg"
  location            = "East US"
  subnet_id           = module.vnet.subnet_ids["AzureFirewallSubnet"]
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the Azure Firewall |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `subnet_id` | `string` | — | ID of the `AzureFirewallSubnet` |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Azure Firewall |
| `private_ip` | The private IP address of the Firewall |
