mock_provider "azurerm" {}

run "validate_mssql_database_config" {
  command = plan

  variables {
    name           = "test-db"
    server_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Sql/servers/test-sql"
    sku_name       = "S0"
    zone_redundant = true

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_mssql_database.db.name == "test-db"
    error_message = "Database name did not match"
  }

  assert {
    condition     = azurerm_mssql_database.db.zone_redundant == true
    error_message = "Zone redundancy should be enabled"
  }
}
