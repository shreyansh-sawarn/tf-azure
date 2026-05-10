# Availability Set Module

Provisions an Azure Availability Set with managed disks enabled for high-availability VM deployments.

## Usage

```hcl
module "availability_set" {
  source              = "../../../modules/compute/availability_set"
  name                = "my-avset"
  resource_group_name = "my-rg"
  location            = "East US"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the Availability Set |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Availability Set |
