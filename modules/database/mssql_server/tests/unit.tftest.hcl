mock_provider "azurerm" {}

run "validate_mssql_server_config" {
  command = plan

  variables {
    name                          = "test-sql-server"
    resource_group_name           = "test-rg"
    location                      = "eastus"
    admin_username                = "sqladmin"
    admin_password                = "P@ssw0rd1234!"
    public_network_access_enabled = false
    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_mssql_server.server.name == "test-sql-server"
    error_message = "SQL Server name did not match"
  }

  assert {
    condition     = azurerm_mssql_server.server.minimum_tls_version == "1.2"
    error_message = "SQL Server must use TLS 1.2"
  }

  assert {
    condition     = azurerm_mssql_server.server.public_network_access_enabled == false
    error_message = "Public network access should be disabled"
  }
}
