# Application Insights Module

Provisions workspace-based Azure Application Insights connected to a Log Analytics Workspace for modern monitoring and diagnostics.

## Usage

```hcl
module "app_insights" {
  source              = "../../../modules/web/app_insights"
  name                = "my-insights"
  resource_group_name = "my-rg"
  location            = "East US"
  workspace_id        = module.log_analytics.id
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the Application Insights resource |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `application_type` | `string` | `"web"` | Application type |
| `workspace_id` | `string` | — | Log Analytics Workspace ID |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `instrumentation_key` | Instrumentation key (sensitive) |
