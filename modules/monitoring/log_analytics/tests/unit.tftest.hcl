mock_provider "azurerm" {}

run "validate_log_analytics_config" {
  command = plan

  variables {
    name                = "test-law"
    location            = "eastus"
    resource_group_name = "test-rg"
    sku                 = "PerGB2018"
    retention_in_days   = 90

    tags = {
      Environment = "test"
      Project     = "portfolio"
    }
  }

  assert {
    condition     = azurerm_log_analytics_workspace.law.name == "test-law"
    error_message = "Log Analytics name did not match"
  }

  assert {
    condition     = azurerm_log_analytics_workspace.law.retention_in_days == 90
    error_message = "Retention days did not match"
  }
}
