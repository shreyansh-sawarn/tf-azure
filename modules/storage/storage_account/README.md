# Storage Account Module

Provisions an Azure Storage Account with HTTPS-only enforcement, TLS 1.2 minimum, and optional blob containers. Defaults to GRS replication.

## Usage

```hcl
module "storage" {
  source              = "../../../modules/storage/storage_account"
  name                = "mystorageacct"
  resource_group_name = "my-rg"
  location            = "East US"
  replication_type    = "GZRS"
  containers          = ["data", "logs", "backups"]
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Storage account name (3-24 chars, lowercase alphanumeric) |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `account_tier` | `string` | `"Standard"` | Performance tier |
| `replication_type` | `string` | `"GRS"` | Replication strategy |
| `containers` | `list(string)` | `[]` | Blob containers to create |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Storage Account |
| `name` | The name of the Storage Account |
| `primary_access_key` | Primary access key (sensitive) |
| `primary_blob_endpoint` | Primary blob service endpoint |
