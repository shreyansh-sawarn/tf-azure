resource "azurerm_mssql_server" "server" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

output "id" { value = azurerm_mssql_server.server.id }
output "fqdn" { value = azurerm_mssql_server.server.fully_qualified_domain_name }

variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "admin_username" { type = string; default = "sqladmin" }
variable "admin_password" { type = string; sensitive = true }
variable "tags" { type = map(string); default = {} }
