resource "azurerm_mssql_database" "db" {
  name                 = var.name
  server_id            = var.server_id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "BasePrice"
  max_size_gb          = var.max_size_gb
  sku_name             = var.sku_name
  zone_redundant       = var.zone_redundant
  storage_account_type = var.storage_account_type
  tags                 = var.tags

  short_term_retention_policy {
    retention_days = var.short_term_retention_days
  }
}
