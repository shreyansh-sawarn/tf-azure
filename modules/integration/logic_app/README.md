# Logic App Module

Provisions an Azure Logic App Workflow for integration and automation scenarios.

## Usage

```hcl
module "logic_app" {
  source              = "../../../modules/integration/logic_app"
  name                = "my-logic"
  resource_group_name = "my-rg"
  location            = "East US"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the Logic App |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Logic App Workflow |
