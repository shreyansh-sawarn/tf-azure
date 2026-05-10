# Private Endpoint Module

Provisions an Azure Private Endpoint with a Private DNS Zone and VNET link for secure, private connectivity to Azure PaaS services. Eliminates public internet exposure for resources like SQL Server and Storage Accounts.

## Usage

```hcl
module "private_endpoint_sql" {
  source              = "../../../modules/networking/private_endpoint"
  name                = "my-sql-pe"
  resource_group_name = "my-rg"
  location            = "East US"
  subnet_id           = module.vnet.subnet_ids["db"]
  vnet_id             = module.vnet.vnet_id
  target_resource_id  = module.mssql_server.id
  subresource_names   = ["sqlServer"]
  dns_zone_name       = "privatelink.database.windows.net"
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the private endpoint |
| `resource_group_name` | `string` | — | Name of the resource group |
| `location` | `string` | — | Azure region |
| `subnet_id` | `string` | — | Subnet ID for the private endpoint |
| `vnet_id` | `string` | — | VNET ID for DNS zone linking |
| `target_resource_id` | `string` | — | ID of the target PaaS resource |
| `subresource_names` | `list(string)` | — | Subresource names (e.g., `["sqlServer"]`, `["blob"]`) |
| `dns_zone_name` | `string` | — | Private DNS zone name |
| `tags` | `map(string)` | `{}` | Resource tags |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Private Endpoint |
| `private_ip` | The private IP address assigned to the endpoint |
