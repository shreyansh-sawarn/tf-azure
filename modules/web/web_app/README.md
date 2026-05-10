# Web App Module

Provisions an Azure Linux Web App with always-on enabled. Requires an existing App Service Plan.

## Usage

```hcl
module "web_app" {
  source              = "../../../modules/web/web_app"
  app_service_name    = "my-webapp"
  resource_group_name = "my-rg"
  location            = "East US"
  service_plan_id     = module.app_service_plan.id
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `app_service_name` | `string` | — | Name of the Web App |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `service_plan_id` | `string` | — | ID of the App Service Plan |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `default_hostname` | The default hostname of the Web App |
