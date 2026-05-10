# Resource Group Module

Provisions an Azure Resource Group as the foundational container for all other resources.

## Usage

```hcl
module "resource_group" {
  source              = "../../../modules/resource_group"
  resource_group_name = "my-project-dev-rg"
  location            = "East US"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `resource_group_name` | The name of the resource group |
| `location` | The Azure region |
