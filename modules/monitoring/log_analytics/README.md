# Log Analytics Workspace Module

Provisions an Azure Log Analytics Workspace for centralized logging and monitoring. Used as the backend for workspace-based Application Insights.

## Usage

```hcl
module "log_analytics" {
  source              = "../../../modules/monitoring/log_analytics"
  name                = "my-law"
  resource_group_name = "my-rg"
  location            = "East US"
  retention_in_days   = 90
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the workspace |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `sku` | `string` | `"PerGB2018"` | Workspace SKU (validated) |
| `retention_in_days` | `number` | `30` | Data retention in days |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Log Analytics Workspace |
| `name` | The name of the workspace |
