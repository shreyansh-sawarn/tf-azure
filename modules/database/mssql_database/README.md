# MSSQL Database Module

Provisions an Azure SQL Database on an existing MSSQL Server with configurable SKU, size, and zone redundancy.

## Usage

```hcl
module "mssql_database" {
  source         = "../../../modules/database/mssql_database"
  name           = "appdb"
  server_id      = module.mssql_server.id
  sku_name       = "GP_Gen5_2"
  zone_redundant = true
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the database |
| `server_id` | `string` | — | ID of the parent MSSQL Server |
| `max_size_gb` | `number` | `2` | Maximum size in GB |
| `sku_name` | `string` | `"S0"` | Database SKU (validated) |
| `zone_redundant` | `bool` | `false` | Enable zone redundancy |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the SQL Database |
