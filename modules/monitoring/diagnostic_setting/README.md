# Diagnostic Setting Module

Provisions an Azure Monitor Diagnostic Setting to stream resource logs and metrics to a Log Analytics Workspace. Reusable across any Azure resource that supports diagnostic settings.

## Usage

```hcl
module "diag_keyvault" {
  source             = "../../../modules/monitoring/diagnostic_setting"
  name               = "diag-kv"
  target_resource_id = module.key_vault.id
  workspace_id       = module.log_analytics.id
  log_categories     = ["AuditEvent"]
  metric_categories  = ["AllMetrics"]
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the diagnostic setting |
| `target_resource_id` | `string` | — | ID of the resource to monitor |
| `workspace_id` | `string` | — | Log Analytics Workspace ID |
| `log_categories` | `list(string)` | `[]` | Log categories to enable |
| `metric_categories` | `list(string)` | `["AllMetrics"]` | Metric categories to enable |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Diagnostic Setting |
