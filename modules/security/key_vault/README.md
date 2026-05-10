# Key Vault Module

Provisions an Azure Key Vault with RBAC authorization enabled (modern model), configurable purge protection, and disk encryption support.

## Usage

```hcl
module "key_vault" {
  source              = "../../../modules/security/key_vault"
  name                = "my-kv"
  resource_group_name = "my-rg"
  location            = "East US"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the Key Vault |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `tenant_id` | `string` | `""` | Azure Tenant ID (auto-detected if empty) |
| `sku_name` | `string` | `"standard"` | SKU: `standard` or `premium` (validated) |
| `purge_protection_enabled` | `bool` | `true` | Enable purge protection |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Key Vault |
| `vault_uri` | The URI of the Key Vault |
