resource "azurerm_mssql_database" "db" {
  name           = var.name
  server_id      = var.server_id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "BasePrice"
  max_size_gb    = var.max_size_gb
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
  tags           = var.tags
}

output "id" { value = azurerm_mssql_database.db.id }

variable "name" { type = string }
variable "server_id" { type = string }
variable "max_size_gb" { type = number; default = 2 }
variable "sku_name" { type = string; default = "S0" }
variable "zone_redundant" { type = bool; default = false }
variable "tags" { type = map(string); default = {} }
