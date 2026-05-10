# App Service Plan Module

Provisions an Azure App Service Plan (Service Plan) for hosting Web Apps and Function Apps. Defaults to Linux OS with B1 SKU.

## Usage

```hcl
module "app_service_plan" {
  source                = "../../../modules/web/app_service_plan"
  app_service_plan_name = "my-asp"
  resource_group_name   = "my-rg"
  location              = "East US"
  sku_name              = "P1v2"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `app_service_plan_name` | `string` | — | Name of the App Service Plan |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `os_type` | `string` | `"Linux"` | OS type (Linux or Windows) |
| `sku_name` | `string` | `"B1"` | Pricing tier SKU |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the App Service Plan |
