# MSSQL Server Module

Provisions an Azure SQL Server with TLS 1.2 enforcement and a firewall rule to allow Azure services. Designed to be used with the `mssql_database` module.

## Usage

```hcl
module "mssql_server" {
  source              = "../../../modules/database/mssql_server"
  name                = "my-sql-server"
  resource_group_name = "my-rg"
  location            = "East US"
  admin_password      = var.sql_admin_password
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the SQL Server |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `admin_username` | `string` | `"sqladmin"` | SQL admin username |
| `admin_password` | `string` | — | SQL admin password (sensitive, min 12 chars) |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the SQL Server |
| `fqdn` | Fully qualified domain name of the server |
