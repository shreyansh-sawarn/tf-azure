# Function App Module

Provisions an Azure Linux Function App for serverless workloads. Requires an App Service Plan and a Storage Account for function storage.

## Usage

```hcl
module "function_app" {
  source                     = "../../../modules/web/function_app"
  function_app_name          = "my-func"
  resource_group_name        = "my-rg"
  location                   = "East US"
  service_plan_id            = module.app_service_plan.id
  storage_account_name       = module.storage.name
  storage_account_access_key = module.storage.primary_access_key
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `function_app_name` | `string` | — | Name of the Function App |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `service_plan_id` | `string` | — | ID of the App Service Plan |
| `storage_account_name` | `string` | — | Storage Account name |
| `storage_account_access_key` | `string` | — | Storage Account access key (sensitive) |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `default_hostname` | The default hostname of the Function App |
